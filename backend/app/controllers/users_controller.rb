class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: 'Usuário criado com sucesso', user: user }, status: :created
    else
      render json: { errors: 'Não foi possível criar seu usuário com os dados enviados, por favor tente novamente com outros dados' }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(id: params[:id])

    if user
      user.destroy
      render json: { message: 'Usuário deletado com sucesso.' }, status: :ok
    else
      render json: { errors: 'Usuário não encontrado' }, status: :not_found
    end
  end

  def get_all
    users = User.all
    render json: { users: users }, status: :ok
  end

  private

  def user_params
    params.permit(:name)
  end
end
