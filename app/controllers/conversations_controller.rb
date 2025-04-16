class ConversationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    conversation = Conversation.new(conversation_params)

    if conversation.save
      render json: { message: 'Conversation created successfully', conversation: conversation }, status: :created
    else
      render json: { errors: conversation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    conversation = Conversation.find_by(id: params[:id].strip)

    if conversation
      conversation.destroy
      render json: { message: 'Conversation deleted successfully' }, status: :ok
    else
      render json: { errors: 'Conversation not found. Try another ID' }, status: :not_found
    end
  end

  def show
    conversation = Conversation.find_by(id: params[:id].strip)

    if conversation
      render json: { conversation: conversation }, status: :ok
    else
      render json: { error: 'Conversation not found' }, status: :not_found
    end
  end

  def by_user
    user_id = params[:id].strip

    conversations = Conversation.where("user_a_id = ? OR user_b_id = ?", user_id, user_id)

    if conversations.any?
      render json: { conversations: conversations }, status: :ok
    else
      render json: { message: 'No conversations found for this user' }, status: :not_found
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
