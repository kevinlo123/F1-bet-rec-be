class AuthenticationController < ApplicationController
  def create
    email = params[:user][:email]
    user = User.find_by(email: email)
    if user && user.authenticate(params[:user][:password])
      render json: { token: generate_token(user.id) }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def generate_token(user_id)
    JWT.encode({ user_id: user_id }, Rails.application.credentials.secret_key_base)
  end
end

