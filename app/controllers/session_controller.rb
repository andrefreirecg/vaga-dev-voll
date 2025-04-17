class SessionController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :authenticate_user, only: [:logout]

    JWT_SECRET = ENV['JWT_SECRET'] || 'secret'
    JWT_EXPIRATION_HOURS = (ENV['JWT_EXPIRATION_HOURS'] || 12).to_i

    def login
      user_id = params[:user_id].to_s.strip
      name = params[:name].to_s.strip

      user = if user_id.present?
              User.find_by(id: user_id)
            elsif name.present?
              User.find_by(name: name)
            end

      if user
        token = generate_token(user.id)
        cookies.signed[:jwt] = {
            value: token,
            expires: JWT_EXPIRATION_HOURS.hours.from_now,
            httponly: true,
            secure: Rails.env.production?
          }
        render json: { message: 'Login realizado', token: token, user: user }, status: :ok
      else
        render json: { error: 'Usuário não encontrado' }, status: :not_found
      end
    end

    def logout
      cookies.delete(:jwt)
      render json: { message: 'Você fez logout' }, status: :ok
    end

    private

    def generate_token(user_id)
      payload = { user_id: user_id, exp: JWT_EXPIRATION_HOURS.hours.from_now.to_i }
      JWT.encode(payload, JWT_SECRET, 'HS256')
    end
  end
