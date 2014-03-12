class Api::V1::AuthenticationsController < Api::V1::BaseController
 
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
    authentication = Authentication.find_by(:uid => params[:uid])
    user = authentication.present? ? User.find(authentication.user_id) : false
    if(!user.present?)
      user = User.new
      user.email = params[:email]
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.password = Devise.friendly_token.first(8)
      user.confirmed_at = Time.now
      user.save!
      if(params[:share_token].present?)
        user.register_shares(params[:share_token])
      end
      user.authentications.create!(:provider => params[:provider], :uid => params[:uid], :token => params[:token])
    end
      render json: {:auth_token => user.authentication_token, status: 'success'} 
  rescue
      render json: {:status => 'error'} 
  end



end