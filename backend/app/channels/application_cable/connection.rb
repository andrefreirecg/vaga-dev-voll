module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = cookies.encrypted[:auth]
      user = User.find_by(authentication_token: token)

      if user
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
