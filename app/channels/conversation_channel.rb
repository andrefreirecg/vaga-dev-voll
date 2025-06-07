class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation_id = params[:conversation_id]
    stream_from "conversation_#{conversation_id}"
  end

  def unsubscribed
    # Qualquer limpeza, se necessário
  end
end
