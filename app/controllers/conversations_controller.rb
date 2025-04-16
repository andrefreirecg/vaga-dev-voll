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
    conversation = Conversation.find_by(id: params[:id])

    if conversation
      conversation.destroy
      render json: { message: 'Conversation deleted successfully' }, status: :ok
    else
      render json: { errors: 'Conversation not found. Try another ID' }, status: :not_found
    end
  end

  private

  def conversation_params
    user_a_id = params.require(:user_a_id)
    user_b_id = params.require(:user_b_id)

    { user_a_id: user_a_id, user_b_id: user_b_id }
  end
end
