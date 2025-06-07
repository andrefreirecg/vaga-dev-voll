class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:create, :get_messages_paginated]

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
      ActionCable.server.broadcast("conversation_#{conversation.id}", {
        message: {
          id: message.id,
          content: message.content,
          user_id: message.user_id,
          conversation_id: message.conversation_id,
          created_at: message.created_at
        }
      })

      render json: { message: 'Mensagem criada com sucesso', data: message }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_messages_paginated
    conversation = Conversation.find_by(id: params[:conversation_id])

    unless conversation
      return render json: { error: 'Conversa não encontrada' }, status: :not_found
    end

    unless [conversation.user_a_id, conversation.user_b_id].include?(@current_user.id)
      return render json: { error: 'Acesso não autorizado' }, status: :unauthorized
    end

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i

    messages = conversation.messages
                          .order(created_at: :desc)
                          .offset((page - 1) * per_page)
                          .limit(per_page)

    render json: { messages: messages }, status: :ok
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end

end
