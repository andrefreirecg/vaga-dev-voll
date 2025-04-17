class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, only: [:create]

    def create
      conversation_id = params[:conversation_id]
      content = params[:content]
      attachment_url = params[:attachment_url]

      conversation = Conversation.find_by(id: conversation_id)

      unless conversation
        return render json: { error: 'Conversa não encontrada' }, status: :not_found
      end

      message = Message.new(
        user_id: @current_user.id,
        conversation_id: conversation.id,
        content: content,
        attachment_url: attachment_url
      )

      if message.save
        render json: { message: 'Mensagem criada com sucesso', message: message }, status: :created
      else
        render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
