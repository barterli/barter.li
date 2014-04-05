# @restful_api 1.0
#
# user creation and getting user objects
#
class Api::V1::AuthenticationsController < Api::V1::BaseController
 FB = OmniAuth::Strategies::Facebook.new("", "") 
 GOOGLE = OmniAuth::Strategies::GoogleOauth2.new("", "") 
 
  def get_auth_token
    authentication = Authentication.find_by(:provider => params[:provider], :uid => params[:uid])
    if authentication
      user = User.find(authentication.user_id)
        render json: {auth_token: user.authentication_token, status: 'success'} 
    else 
        render json: {error_code: Code[:error_no_resource]}, status: Code[:status_error]
    end
  end

  # @url /api/v1/create_user
  # @action POST
  #
  # creates a user if not present or returns a user with location
  # supports two types of authentication normal email , password and 
  # outh(facebook or google)
  #
  # @required [String] format only json supported 
  # @required [String] email used if provider is manual
  # @required [String] password used if provider is manual (minimum 8 characters)
  # @required [String] access_token used if provider is outh(facebook or google)
  # @required [String] provider can be manual, facebook, google
  #
  # @response [User] The created user or existing user
  # 
  # @example_request_description Let's try to create a user
  # @example_request
  #    ```json
  #    {
  #     "password": "12345678"
  #     "email": "example@gmail.com"
  #     "provider": "manual"
  #    }
  #    or
  #    {
  #     "access_token": "1hdbfdfgbdbgdfkj94589hbvjdf"
  #     "provider": "facebook"
  #    }
  #    ```
  # @example_response_description The user should be created correctly
  # @example_response
  #    ```json
  #    {
  #     "user": {
  #         "id": 25,
  #         "email": "example@gmail.com",
  #         "description": test,
  #         "first_name": test,
  #         "last_name": test,
  #         "location": {
  #             "id": 6,
  #             "country": "34535",
  #             "state": bihar,
  #             "city": patna,
  #             "name": coffee day,
  #             "latitude": "12.334",
  #             "longitude": "12.445",
  #             "address": 201, cross street
  #         },
  #         "auth_token": "TRU2uUh1DxfyTdi3tnEs",
  #         "sign_in_count": 33,
  #         "books": []
  #      }
  #    }
  #    ```
  def create_user
    case params[:provider]
      when "facebook"
        facebook
      when "manual"
        manual
      when "google"
        google
      else
        render json:{error_code: Code[:error_no_resource]}, status: Code[:status_error]
    end
  end

  def facebook
    client = OAuth2::Client.new("", "", FB.options.client_options) 
    token = OAuth2::AccessToken.new(client, params[:access_token], FB.options.access_token_options)
    FB.access_token = token
    authentication = Authentication.where(:uid => FB.auth_hash["uid"], :provider => "facebook").first
    user = authentication.present? ? User.find(authentication.user_id) : false
    if(!user.present?)
      user = User.find_by(email: FB.auth_hash["extra"]["raw_info"]["email"]) 
      user = user.present? ? user : User.new
      unless user.persisted?
        user.email = FB.auth_hash["extra"]["raw_info"]["email"]
        user.first_name = FB.auth_hash["extra"]["raw_info"]["first_name"]
        user.last_name = FB.auth_hash["extra"]["raw_info"]["last_name"]
        user.password = Devise.friendly_token.first(8)
        user.confirmed_at = Time.now
        user.save!
      end
      register_shares(user)
      user.authentications.create!(:provider => "facebook", :uid => FB.auth_hash["uid"], :token => params[:access_token])
    end
      render json: user  
  #rescue => e
      #render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error] 
  end
   

  def google
    client = OAuth2::Client.new("", "", GOOGLE.options.client_options) 
    token = OAuth2::AccessToken.new(client, params[:access_token], FB.options.access_token_options)
    GOOGLE.access_token = token
    binding.pry
    authentication = Authentication.where(:uid => GOOGLE.auth_hash["uid"], :provider => "google").first
    user = authentication.present? ? User.find(authentication.user_id) : false
    if(!user.present?)
      user = User.find_by(email: GOOGLE.auth_hash["extra"]["raw_info"]["email"]) 
      user = user.present? ? user : User.new
      unless user.persisted?
        user.email = GOOGLE.auth_hash["extra"]["raw_info"]["email"]
        user.first_name = GOOGLE.auth_hash["extra"]["raw_info"]["first_name"]
        user.last_name = GOOGLE.auth_hash["extra"]["raw_info"]["last_name"]
        user.password = Devise.friendly_token.first(8)
        user.confirmed_at = Time.now
        user.save!
      end
      register_shares(user)
      user.authentications.create!(:provider => "facebook", :uid => FB.auth_hash["uid"], :token => params[:access_token])
    end
      render json: user 
  rescue => e
      render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end

  def register_shares(user)
    if(params[:share_token].present?)
      user.register_shares(params[:share_token])
    end
  end
  
  def manual
    user = User.create_or_find_by_email_and_password(params[:email], params[:password])
    if(user)
      register_shares(user)
      render json: user
    else
      render json: {error_code: Code[:error_email_taken], error_message: "incorrect credentials"}, status: Code[:status_error]
    end
  # rescue => e
  #     render json: {error_code: Code[:error_rescue], error_message: e.message}, status: Code[:status_error]
  end
end