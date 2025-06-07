class MetricsController < ApplicationController
  def get_metrics
    users = User.all.map do |user|
      {
        id: user.id,
        name: user.name,
        messages_count: Message.where(user_id: user.id).count,
        conversations_count: Conversation.where("user_a_id = ? OR user_b_id = ?", user.id, user.id).count
      }
    end

    render json: {
      usuarios_total: users,
      total_mensagens: Message.count,
      total_conversas: Conversation.count
    }
  end
end
