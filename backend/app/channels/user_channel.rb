class UserChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id] || current_user.id
    stream_from "user_#{user_id}"
  end

  def unsubscribed
    user_id = params[:user_id] || current_user.id
    user = User.find_by(id: user_id)

    if user
      user.update(authentication_token: nil)
    end
  end
end
