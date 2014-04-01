# @restful_api 1.0
#
# user creation and getting user objects
#
class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:update, :show, :get_share_token, :generate_share_token,
    :set_user_preferred_location, :user_preferred_location]
  
  

  # @url /user_profile
  # @action GET 
  # 
  # get profile of a user
  #
  # @required [Integer] id id of the user
  # @example_request_description Let's send a id of a user
  # 
  # @example_request
  #    ```json
  #    {  
  #     id: 5
  #     }
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #    {
  #      
  #      "user": {
  #      "email": "test@gmail.com",
  #       "first_name": "test",
  #      "last_name": "test"
  #     }
  #    }
  #    ```
  def user_profile
    user  = User.find(params[:id])
    setting = user.settings.find_by(name: "location")
    location = setting.present? ? Location.find(setting.value) : false 
    # if stale?(:etag => "user_profile_"+user.id, :last_modified => user.updated_at, :public => true)
      render :json => {user: user.as_json(only: [:first_name, :last_name, :email])}
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
  

  # @url /password_reset
  # @action GET 
  # 
  # send password reset token
  #
  # @required [String] email Email to send reset password token
  #
  # @response [User] The user object
  #
  # @example_request_description Let's send a password reset token
  # 
  # @example_request
  #    ```json
  #    {
  #      "email": "test@example.com"
  #    }
  #    ```
  # @example_response_description empty object with status 200
  # @example_response
  #    ```json
  #       {
  #      
  #       }
  #    }
  #    ```
  def send_password_reset
    user = User.find_by(email: params[:email])
    if(user)
      user.send_password_reset
      render json: {}
    else
      render json: {error_code: Code[:error_resource], error_message: "no user found"}, status: Code[:status_error]
    end
  end
 
  # @url /password_reset
  # @action POST
  # 
  # set password reset 
  #
  # @required [String] email Email to set password
  # @required [String] token Token send to your email
  # @required [String] password New password to set
  # @example_request_description Let's set a password 
  # 
  # @example_request
  #    ```json
  #    {
  #      "email": "test@example.com",
  #      "password": "12345678",
  #      "token": "67059910"
  #    }
  #    ```
  # @example_response_description gives user object
  # @example_response
  #    ```json
  #      {
  #          "user": {
  #              "id": 9,
  #              "email": "surendarft@gmail.com",
  #              "description": null,
  #              "first_name": "surendar",
  #              "last_name": "ghgf",
  #              "location": null,
  #              "auth_token": "Qj2egLZTwe812gxSpDd8",
  #              "sign_in_count": 1,
  #              "id_user": null,
  #             "books": [
  #                  {
  #                      "id": 21,
  #                      "title": "rails",
  #                      "author": "rails-to-trails",
  #                      "publication_year": 2007,
  #                      "publication_month": "January",
  #                      "image_url": "http://localhost:3000/uploads/book/image/21/1662213-S.jpg",
  #                      "barter_type": null,
  #                      "location": null,
  #                      "tags": [],
  #                      "id_book": null
  #                  }
  #              ]
  #          }
  #      }
  #      ```
  def reset_password
    user = User.find_by(reset_password_token: params[:token], email: params[:email])
    if(user.reset_password_sent_at > Time.now - 20.minutes)
      user.password = params[:password]
      user.reset_password_token = ""
      user.save!
      render json: user
    else
      render json: {error_code: Code[:error_resource], error_message: "token expired"}, status: Code[:status_error] 
    end
  rescue => e
     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]  
  end
  
  # @url /user_preferred_location
  # @action POST
  #
  # set user preferred location
  #
  # @required [String] latitude Latitude coordinate
  # @required [String] longitude Longitude coordinate
  # @optional [String] country Country
  # @optional [String] state State
  # @optional [String] city City
  # @optional [String] name Name
  #
  # @response [Location] The created book
  #
  # @example_request_description Let's try to create a location
  # @example_request
  #    ```json
  #    {
  #      "latitude": "12.7777",
  #      "longitude": "12.34546",
  #    }
  #    ```
  # @example_response_description The location should be created correctly
  # @example_response
  #    ```json
  #    {
  #       "location": {
  #        "id": 17,
  #        "latitude": "12.7777",
  #        "longitude": "12.34546",
  #        "country": null,
  #        "city": null,
  #        "state": null,
  #        "address": null,
  #        "name": null,
  #        "id_location": "804f2bbb36fd58ee"
  #      }
  #    }
  #    ```
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