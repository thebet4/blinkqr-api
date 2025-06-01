class UsersController < ApplicationController
  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
        render json: 
        { 
            user: {
                id: @user.id,
                username: @user.username,
                created_at: @user.created_at,
                updated_at: @user.updated_at
            }, 
        }, status: :created
    else
        render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
        params.permit(:username, :password, :email, :password_confirmation)
    end
end
