class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          # User authentication successful
          # Generate and return a token (e.g., JWT) for the user
          token = generate_token(user.id)
          render json: { token: token }
        else
          # User authentication failed
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def destroy
        # Implement logout logic here
        # For example, invalidate the user's token or session
        render json: { message: 'Logged out successfully' }
    end
    
    private

        def generate_token(user_id)
        # Implement token generation logic here (e.g., using JWT)
        # Example JWT token generation:
        # JWT.encode({ user_id: user_id }, Rails.application.secrets.secret_key_base)
        end
end
