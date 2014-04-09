class Api::V1::BaseController < ActionController::API
  # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::HttpAuthentication::Token
  before_action :authenticate_user_from_token!

  private
    def authenticate_user_from_token!
      request.format = "json"
      user_token = token_and_options(request).presence
      return if user_token.blank?
      user_email = user_token[1][:email].presence 
      user = user_email && User.find_by_email(user_email)
      if user && Devise.secure_compare(user.authentication_token, user_token[0])
        sign_in user, store: false
      end
    end



end