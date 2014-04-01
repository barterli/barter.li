class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update, :show, :get_share_token, :generate_share_token,
    :set_user_preferred_location, :user_preferred_location]
  
  # GET '/user_profile'
  def user_profile
    user  = User.find(params[:id])
    setting = user.settings.find_by(name: "location")
    location = setting.present? ? Location.find(setting.value) : false 
    # if stale?(:etag => "user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
      render :json => {user: user, books: user.books}
    # end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # GET '/current_user_profile'
  def show
    user  = current_user
    # if stale?(:etag => "current_user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
      render :json => {user: user, books: user.books}
    # end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def update
    user  = current_user
    if(user.update_attributes(user_profile_params))
      render json: user
    else
      render json: {error_code: Code[:error_resource], error_message: user.errors.full_messages},  status: Code[:status_error]
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_profile_image
    image_url = User.find(params[:id]).image.url
    render json: {image_url: image_url, status: :success}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def set_profile_image
    current_user.profile = params[:profile]
    current_user.save!
    render json: {image_url: image_url, status: :success}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  # GET /password_reset
  def send_password_reset
    user = User.find_by(email: params[:email])
    if(user)
      user.send_password_reset
      render json: {}
    else
      render json: {error_code: Code[:error_resource], error_message: "no user found"}, status: Code[:status_error]
    end
  end
 
  # POST /password_reset
  def reset_password
    user = User.find_by(reset_password_token: params[:token], email: params[:email])
    if(user.reset_password_sent_at > Time.now - 20.minutes)
      user.password = params[:password]
      user.save!
      render json: {user: user}
    else
      render json: {error_code: Code[:error_resource], error_message: "token expired"}, status: Code[:status_error] 
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]  
  end


  # POST /prefered_location
  def set_user_preferred_location
    location = current_user.set_preferred_location(params)
      if location
        render :json => location 
      else
        render :json => {error_code: Code[:error_resource], error_message: "location not created"}, status: Code[:status_error]
      end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end 

  # GET /prefered_location
  def get_user_preferred_location
    location = current_user.preferred_location
    if(location)
      render json: location
    else
      render json: {location: nil}
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
 
  def generate_share_token
    token = current_user.generate_share_token
    render :json => {share_token: token}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def get_share_token
    token = current_user.share_token 
    render :json => {share_token: token}
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

 private
    def user_profile_params
      params[:user_profile] = JSON.parse(params[:user])
      if(params[:profile].present?)
        params[:user_profile][:user][:profile] = params[:profile]
      end
      params[:user_profile].require(:user).permit(:first_name, :last_name, :description, :email, :profile
      )
    end
end