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
      if user.authentication_token.present?
        render json: { error: 'Usuário já logado' }, status: :unauthorized
        return
      end

      token = generate_token(user.id)
      cookies.signed[:auth] = {
        value: token,
        expires: JWT_EXPIRATION_HOURS.hours.from_now,
        httponly: true,
        secure: Rails.env.production?,
      }
      user.update(authentication_token: token, last_login_at: Time.now)
      render json: { message: "Login realizado - Bem vindo(a) #{user.name}", token: token, user: user }, status: :ok
    else
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    end
  end

  def logout
    if @current_user
      @current_user.update(authentication_token: nil)
      cookies.delete(:auth)
      render json: { message: 'Você fez logout' }, status: :ok
    else
      render json: { error: 'Usuário não autenticado' }, status: :unauthorized
    end
  end

  def me
    token = cookies.signed[:auth]
    if token
      begin
        decoded_token = decode_token(token)
        user_id = decoded_token[0]["user_id"]
        user = User.find_by(id: user_id)

        if user
          render json: { message: "Usuário identificado - Bem vindo(a) #{user.name}", token: token, user: user }, status: :ok
        else
          render json: { error: 'Usuário não encontrado' }, status: :not_found
        end
      rescue JWT::DecodeError
        render json: { error: 'Token inválido' }, status: :unauthorized
      end
    else
      render json: { error: 'Token não encontrado' }, status: :unauthorized
    end
  end

  private

  def generate_token(user_id)
    payload = { user_id: user_id, exp: JWT_EXPIRATION_HOURS.hours.from_now.to_i }
    JWT.encode(payload, JWT_SECRET, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')
  rescue JWT::ExpiredSignature
    nil
  end

  def authenticate_user
    token = cookies.signed[:auth]

    decoded = decode_token(token)
    return render json: { error: 'Token inválido ou expirado' }, status: :unauthorized unless decoded

    user_id = decoded[0]['user_id']
    Rails.logger.debug("user_id: #{user_id}")
    @current_user = User.find_by(id: user_id, authentication_token: token)

    render json: { error: 'Não autorizado' }, status: :unauthorized unless @current_user
  end


end
