class Api::V1::AuthenticationsController < Api::V1::BaseController
 FB = OmniAuth::Strategies::Facebook.new("", "") 
 GOOGLE = OmniAuth::Strategies::GoogleOauth2.new("", "") 
 # post api/v1/auth_token
  def get_auth_token
    authentication = Authentication.find_by(:provider => params[:provider], :uid => params[:uid])
    if authentication
      user = User.find(authentication.user_id)
        render json: {auth_token: user.authentication_token, status: 'success'} 
    else
        render json: {status: 'error'}
    end
  end

  # post api/v1/create_user
  def create_user
    case params[:provider]
      when "facebook"
        facebook
      when "manual"
        manual
      when "google"
        google
      else
        render json:{status: :error}
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
      render json: {:auth_token => user.authentication_token, status: 'success', location: user.preferred_location} 
  rescue
      render json: {:status => 'error'} 
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
      render json: {:auth_token => user.authentication_token, status: 'success', location: user.preferred_location} 
  rescue
      render json: {:status => 'error'} 
  end

  def register_shares(user)
    if(params[:share_token].present?)
      user.register_shares(params[:share_token])
    end
  end
  
  def manual
    user = User.create_or_find_by_email_and_password(params[:email], params[:password])
    register_shares(user)
    render json: {:auth_token => user.authentication_token, status: 'success', location: user.preferred_location} 
  rescue
      render json: {:status => 'error'} 
  end

end