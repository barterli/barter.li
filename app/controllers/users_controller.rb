class UsersController < ApplicationController
  before_action :authenticate_user!
  respond_to :json, :html, only: [ :create_user_review ]
  
  # edit profile of the user
  # get /profile
  def edit_profile
  	@user = current_user
  end
 
  def user_profile
    @user  = User.find(params[:id])
    @setting = @user.settings.find_by(name: "location")
    @location = @setting.present? ? Location.find(setting.value) : false 
  end
  
  # post /prefered_location
  def set_prefered_location
    location = current_user.set_preferred_location(params)
    respond_to do |format|
      if location
        format.json { render :json => {status: :created} }
      else
        format.json { render :json => {status: :error} }
      end
    end
  end  
  
  # patch /profile
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
  
  # post /user_reviews
  def create_user_review
    @user_review = UserReview.new(user_review_params)
      if @user_review.save
        respond_with(@user_review) 
      else
        respond_with(@user_review.errors)
      end
  end


  def my_library
    @books = current_user.books.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html { render template: "search/search_books" }
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

    def user_review_params
      params.require(:user_review).permit(:body, :user_id)
    end

end



