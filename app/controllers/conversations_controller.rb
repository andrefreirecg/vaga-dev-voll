class ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:create, :destroy, :show, :by_user]

  def create
    conversation = Conversation.new(conversation_params)

    if conversation.save
      render json: { message: 'Conversa criada com sucesso', conversation: conversation }, status: :created
    else
      render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    conversation = Conversation.find_by(id: params[:id].strip)

    if conversation
      conversation.destroy
      render json: { message: 'Conversa deletada com sucesso' }, status: :ok
    else
      render json: { errors: 'Conversa não encontrada' }, status: :not_found
    end
  end

  def show
    conversation = Conversation.find_by(id: params[:id].strip)

    if conversation
      render json: { conversation: conversation }, status: :ok
    else
      render json: { error: 'Conversa não encontrada' }, status: :not_found
    end
  end

  def by_user
    user_id = params[:id].strip

    conversations = Conversation.where("user_a_id = ? OR user_b_id = ?", user_id, user_id)

    if conversations.any?
      render json: { conversations: conversations }, status: :ok
    else
      render json: { message: 'Nenhuma conversa encontrada para esse usuário' }, status: :not_found
    end
  end


  private

  # Params function
  def conversation_params
    user_a_id = params.require(:user_a_id).strip
    user_b_id = params.require(:user_b_id).strip

    { user_a_id: user_a_id, user_b_id: user_b_id }
  end
end
