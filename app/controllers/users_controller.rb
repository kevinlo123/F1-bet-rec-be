class UsersController < ApplicationController
   before_action :authenticate_request, only: [:index, :show, :destroy, :update]
   before_action :find_user, only: [:show, :destroy, :update]

   def index
      @users = User.all
      if @users.any?
         render json: @users, status: :ok
      end
   end

   def create
      user = User.new(user_params)
      if user.save
         render json: { token: generate_token(user.id), new_user: user }, status: :created
      else
         render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
   end

   def show
      render json: { message: 'Showing User', user: @user }, status: :ok
   end

   def destroy
      @user.destroy
      render json: { message: 'User deleted successfully', deleted_user: @user }, status: :ok
   end

   def update
      if @user.update(user_params)
         render json: { message: 'User updated successfully', user: @user }, status: :ok
      else
         render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
   end

   private

   def user_params
      params.require(:user).permit(:email, :password)
   end

   def generate_token(user_id)
      JWT.encode({ user_id: user_id }, Rails.application.credentials.secret_key_base)
   end

   def find_user
      @user = User.find(params[:id])
   rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
   end

   def user_signed_in?
      !!@current_user
   end

   def authenticate_request
      token = request.headers['Authorization']
      if token.present?
         begin
            decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
            user_id = decoded_token[0]['user_id']
            @current_user = User.find(user_id)
         rescue JWT::DecodeError
            render json: { error: 'Invalid token' }, status: :unauthorized
         rescue ActiveRecord::RecordNotFound
            render json: { error: 'User not found with token' }, status: :unauthorized
         end
      else
         render json: { error: 'Token not present' }, status: :unauthorized
      end
   end  
end
