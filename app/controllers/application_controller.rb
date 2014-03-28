class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session, :except => [:create]
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::HttpAuthentication::Token
  before_action :authenticate_user_from_token!

  private
    def authenticate_user_from_token!
      user_token = token_and_options(request).presence
      user_email = user_token[1][:email].presence 
      user = user_email && User.find_by_email(user_email)
      if user && Devise.secure_compare(user.authentication_token, user_token[0])
        sign_in user, store: false
      end
    end

end
