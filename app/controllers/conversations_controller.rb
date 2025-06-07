class ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:create, :destroy, :show, :by_user]

  def create
    user_a = find_user(params[:user_a_id])
    user_b = find_user(params[:user_b_id])

    if user_a.nil? || user_b.nil?
      return render json: { errors: ['Usuário não encontrado'] }, status: :not_found
    end

    existing_conversation = Conversation
      .includes(:user_a, :user_b, :messages)
      .find_by(user_a_id: user_a.id, user_b_id: user_b.id) ||
      Conversation
      .includes(:user_a, :user_b, :messages)
      .find_by(user_a_id: user_b.id, user_b_id: user_a.id)



    if existing_conversation
      if existing_conversation.user_a_deleted || existing_conversation.user_b_deleted
        existing_conversation.update(user_a_deleted: false, user_b_deleted: false)
        return render json: { message: 'Conversa reativada com sucesso', conversation: conversation_with_messages(existing_conversation) }, status: :ok
      else
        return render json: { errors: ['Conversa já existe'], conversation: conversation_with_messages(existing_conversation) }, status: :unprocessable_entity
      end
    end

    conversation = Conversation.new(user_a_id: user_a.id, user_b_id: user_b.id)
    if conversation.save
      render json: { message: 'Conversa criada com sucesso', conversation: conversation_with_messages(conversation) }, status: :created
    else
      render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    conversation = Conversation.find_by(id: params[:id].strip)
    return render json: { error: 'Conversa não encontrada' }, status: :not_found unless conversation

    unless authorized_for_conversation?(conversation)
      return render json: { error: 'Você não pode deletar essa conversa' }, status: :unauthorized
    end

    if @current_user.id == conversation.user_a_id
      conversation.update(user_a_deleted: true)
    elsif @current_user.id == conversation.user_b_id
      conversation.update(user_b_deleted: true)
    end

    if conversation.user_a_deleted && conversation.user_b_deleted
      conversation.destroy
      render json: { message: 'Conversa apagada permanentemente' }, status: :ok
    else
      render json: { message: 'Conversa marcada como deletada para você' }, status: :ok
    end
  end


  def show
    conversation = Conversation.find_by(id: params[:id].strip)

    unless authorized_for_conversation?(conversation)
      return render json: { error: 'Você não pode ver essa conversa' }, status: :unauthorized
    end

    if (@current_user.id == conversation.user_a_id && conversation.user_a_deleted) ||
      (@current_user.id == conversation.user_b_id && conversation.user_b_deleted)
      return render json: { error: 'Conversa não encontrada' }, status: :not_found
    end

    if conversation
      render json: { conversation: conversation }, status: :ok
    else
      render json: { error: 'Conversa não encontrada' }, status: :not_found
    end
  end

  def by_user
    user_id = @current_user.id

    conversations = Conversation.where("user_a_id = ? OR user_b_id = ?", user_id, user_id)

    filtered_conversations = conversations.select do |c|
      if user_id == c.user_a_id
        !c.user_a_deleted
      elsif user_id == c.user_b_id
        !c.user_b_deleted
      else
        false
      end
    end

    if filtered_conversations.any?
      render json: { conversations: filtered_conversations.map { |c| conversation_with_messages(c) } }, status: :ok
    else
      render json: { message: 'Nenhuma conversa encontrada para esse usuário' }, status: :not_found
    end
  end




  private

  def conversation_with_messages(conversation)
    {
      id: conversation.id,
      user_a: {
        id: conversation.user_a.id,
        name: conversation.user_a.name
      },
      user_b: {
        id: conversation.user_b.id,
        name: conversation.user_b.name
      },
      messages_count: conversation.messages_count,
      created_at: conversation.created_at,
      updated_at: conversation.updated_at,
      messages: conversation.messages.order(created_at: :desc).limit(1).map do |m|
        {
          id: m.id,
          content: m.content,
          attachment_url: m.attachment_url,
          user_id: m.user_id,
          created_at: m.created_at
        }
      end
    }
  end

  def authorized_for_conversation?(conversation)
    [conversation.user_a_id, conversation.user_b_id].include?(@current_user.id)
  end

  def conversation_params
    params.permit(:user_a_id, :user_b_id)
  end
  def find_user(id_or_name)
    User.find_by(id: id_or_name) || User.find_by(name: id_or_name)
  end
end
