class UserChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id] || current_user.id
    stream_from "user_#{user_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
