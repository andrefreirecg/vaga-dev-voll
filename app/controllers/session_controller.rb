class SessionController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_user, only: [:logout]

    JWT_SECRET = ENV['JWT_SECRET'] || 'secret'
    JWT_EXPIRATION_HOURS = ENV['JWT_EXPIRATION_HOURS'] || 12

    def login
      user_id = params[:user_id].to_s.strip
      user = User.find_by(id: user_id)

      if user
        token = generate_token(user.id)
        cookies.signed[:jwt] = {
            value: token,
            expires: JWT_EXPIRATION_HOURS.hours.from_now,
            httponly: true,
            secure: Rails.env.production?
          }
        render json: { message: 'Login successful', token: token, user: user }, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end

    def logout
      cookies.delete(:jwt)
      render json: { message: 'Logout successful' }, status: :ok
    end

    private

    def generate_token(user_id)
      payload = { user_id: user_id, exp: JWT_EXPIRATION_HOURS.hours.from_now.to_i }
      JWT.encode(payload, JWT_SECRET, 'HS256')
    end
  end
