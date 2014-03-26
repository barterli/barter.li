class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session, :except => [:create]
  include ActionController::MimeResponds
  include ActionController::Cookies
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_from_token!

 
private
  def authenticate_user_from_token!
    return if params[:user_token].blank?
    user_email = params[:user_email].presence # return nil if object is empty
	  user = user_email && User.find_by_email(user_email)
	# Notice how we use Devise.secure_compare to compare the token
	# in the database with the token given in the params, mitigating
	# timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
	  sign_in user, store: false
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :description) }
  end


end
