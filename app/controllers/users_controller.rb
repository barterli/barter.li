class UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :json, :html 
  
  #edit profile of the user
  def edit_profile
  	@user = current_user
  end

  def update_profile
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to root_path, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit_profile' }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # wish list for book title and author
  def add_wishlist
    @wishlist = current_user.wish_lists.new(wish_list_params)
    if(@wishlist.save)
      respond_with(:status => "success")
    else
      respond_with(:status => "error")
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, 
      :middle_name, :gender, :age, :birthday, :anniversary, :occupancy, 
      :marital_status, :mobile, :region, :country, :state, :city, :street,
      :address, :pincode, :latitude, :locality, :longitude, :accuracy, :altitude)
    end

    def wish_list_params
      params.require(:wish_list).permit(:tilte, :author)
    end 

end



