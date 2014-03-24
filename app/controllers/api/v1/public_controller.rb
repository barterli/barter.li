class PublicController < Api::V1::BaseController

	 def index


   end


   def welcome
     if stale?(:etag => 'welcome page', :last_modified => Code[:etag_last_modified], :public => true)
       @register = Register.new
       render layout: "welcome"
     end
   end

  def register
    @register = Register.new
    @register.email = params[:register][:email]
    @register.register_type = params[:register][:register_type]
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
