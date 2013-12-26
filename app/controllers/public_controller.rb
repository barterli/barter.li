class PublicController < ApplicationController

	def index


    end


    def welcome
     
     @register = Register.new
     render layout: "welcome"
    
    end

    def register_email
      @register = Register.new
      @register.email = params[:register][:email]
      if(@register.save)
      	flash[:notice] = "You will receive a notification when the product is live"
        redirect_to root_path
      else
        flash[:alert] = "Sorry! looks like invalid email"
        redirect_to root_path
      end
      
    end


   def careers


   end

end
