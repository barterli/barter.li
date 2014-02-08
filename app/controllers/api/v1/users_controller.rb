class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update]
  
  def show
    user  = User.find(params[:id])
    respond_with user
  end

  def update
    user  = User.find(params[:id])
    if(user.update_attributes(user_params))
      render json: status: :success, user: user
    else
      render json: status: :error
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :description, :email
      )
    end
end