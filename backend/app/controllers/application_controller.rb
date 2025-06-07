class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  JWT_SECRET = ENV['JWT_SECRET'] || 'secret'
  def route_not_found
    render json: { error: 'Rota não encontrada' }, status: :not_found
  end
  def authenticate_user
    token = cookies.signed[:auth]

    if token
      begin
        decoded_token = JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' })
        user_id = decoded_token[0]["user_id"]
        @current_user = User.find_by(id: user_id)
        if @current_user.nil?
          render json: { error: 'User not found' }, status: :unauthorized
          return
        end
        return @current_user
      rescue JWT::DecodeError
        render json: { error: 'Invalid token', log: token }, status: :unauthorized
        return
      end
    else
      render json: { error: 'Authentication is required.' }, status: :unauthorized
      return
    end
  end

end
