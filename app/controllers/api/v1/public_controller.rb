class Api::V1::PublicController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:register]
	
  def index


  end


   def welcome
     if stale?(:etag => 'welcome page', :last_modified => Code[:etag_last_modified], :public => true)
       @register = Register.new
       render layout: "welcome"
     end
   end

  # POST /register
  def register
    @register = Register.new
    @register.email = current_user.email
    @register.body = params[:message]
    @register.register_type = params[:register_type]
    if(@register.save)
    	render json: {status: :success}
    else
      render json: {status: :error}
    end 
  end
 
   def collaborate
     if stale?(:etag => 'Collabarate', :last_modified => Code[:etag_last_modified], :public => true)
       render layout: "welcome"
     end
   end

end
