class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update]
  
  def show
    user  = User.find(params[:id])
    setting = self.settings.find_by(name: "location")
    location = setting.present? ? Location.find(location.value) : false 
    render :json => {user: user, books: user.books, preferred_location: location }
  end

  def update
    user  = current_user
    if(user.update_attributes(user_params))
      render json: {status: :success, user: user}
    else
      render json: {status: :error}
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :description, :email
      )
    end
end