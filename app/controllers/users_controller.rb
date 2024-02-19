class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { token: generate_token(user.id) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def generate_token(user_id)
    JWT.encode({ user_id: user_id }, Rails.application.secrets.secret_key_base)
  end
end

