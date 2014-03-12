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
      	flash[:notice] = "You will receive a notification when the product is live"
        redirect_to root_path
      else
        flash[:alert] = "Sorry! looks like invalid email"
        redirect_to root_path
      end
      
    end
 
   def generate_share_link


   end

   def collaborate
     if stale?(:etag => 'Collabarate', :last_modified => Code[:etag_last_modified], :public => true)
       render layout: "welcome"
     end
   end

end
