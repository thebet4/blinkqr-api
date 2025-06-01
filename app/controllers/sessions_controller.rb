class SessionsController < ApplicationController
    def create
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            token = encode_token({ user_id: @user.id })
            refresh_token = SecureRandom.hex(32)

            @user.update_column(:refresh_token, refresh_token)
            render json: 
            { 
                access_token: token,
                refresh_token: refresh_token
            }, 
            status: :ok
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    def refresh
        refresh_token = request.headers["Authorization"].split(" ").last
        
        @user = User.find_by(refresh_token: refresh_token)
        if @user
            refresh_token = SecureRandom.hex(32)
            @user.update_column(:refresh_token, refresh_token)
            token = encode_token({ user_id: @user.id })
            render json: { access_token: token, refresh_token: refresh_token }, status: :ok
        else
            render json: { error: "Invalid refresh token" }, status: :unauthorized
        end
    end


end
