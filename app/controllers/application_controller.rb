class ApplicationController < ActionController::API
    before_action :authenticate_request
  
    private
  
    def authenticate_request
      token = request.headers['Authorization']&.split(' ')&.last
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)&.first
      @current_user = User.find(decoded_token['user_id']) if decoded_token
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
end
  
