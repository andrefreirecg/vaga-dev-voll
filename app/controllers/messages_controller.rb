class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user, only: [:create, :get_messages_paginated, :delete]

  def create
    conversation_id = params[:conversation_id]
    content = params[:content]
    attachment_url = params[:attachment_url]

    conversation = Conversation.find_by(id: conversation_id)

    unless authorized_for_conversation?(conversation)
      return render json: { error: 'Você não pode criar mensagens aqui' }, status: :unauthorized
    end
    unless conversation
      render json: { error: 'Conversa não encontrada' }, status: :not_found
      return
    end

    message = Message.new(
      user_id: @current_user.id,
      conversation_id: conversation.id,
      content: content,
      attachment_url: attachment_url
    )

    if message.save
      user_a_id = conversation.user_a_id
      user_b_id = conversation.user_b_id

      [user_a_id, user_b_id].uniq.each do |user_id|
        ActionCable.server.broadcast("user_#{user_id}", {
          type: 'message_created',
          message: {
            id: message.id,
            content: message.content,
            user_id: message.user_id,
            conversation_id: message.conversation_id,
            created_at: message.created_at
          }
        })
      end

      render json: { message: 'Mensagem criada com sucesso', data: message }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete
    message = Message.find_by(id: params[:id])

    unless message
      return render json: { error: 'Mensagem nao encontrada' }, status: :not_found
    end
    conversation = Conversation.find_by(id: message.conversation_id)

    unless authorized_for_conversation?(conversation)
      return render json: { error: 'Você não pode apagar essa mensagem' }, status: :unauthorized
    end

    message.destroy
    user_a_id = conversation.user_a_id
    user_b_id = conversation.user_b_id

    [user_a_id, user_b_id].uniq.each do |user_id|
      ActionCable.server.broadcast("user_#{user_id}", {
        type: 'message_deleted',
        message: {
          id: params[:id]
        }
      })
    end
    render json: { message: 'Mensagem deletada com sucesso' }, status: :ok
  end

    def get_messages_paginated
      conversation = Conversation.find_by(id: params[:conversation_id])

    unless authorized_for_conversation?(conversation)
      return render json: { error: 'Você não pode ver as mensagens dessa conversa' }, status: :unauthorized
    end

    unless conversation
      return render json: { error: 'Conversa não encontrada' }, status: :not_found
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
  def authorized_for_conversation?(conversation)
    Rails.logger.debug("current_user: #{@current_user}")
    if @current_user.nil?
      return false
    end
    [conversation.user_a_id, conversation.user_b_id].include?(@current_user.id)
  end
end
