class Api::V1::BartersController < Api::V1::BaseController
  before_action :authenticate_user!

  def send_barter_notification
    book = Book.find(params[:book_id])
    book_owner = User.find(book.user_id)
    if(Notifier.barter_request(book_owner, current_user, book, params[:message]).deliver)
      render json: {status: :success}
    else
      render json: {status: :error}
    end
  end

   # get /barter/new
  def new
    @barter = Barter.new
    @barter.notifications.build
    @book_id = params[:book_id]
  end

  def create
    @book_id = params[:barter][:book_id]
    @book = Book.find(@book_id)
    @notifier_id = @book.user.id
    @barter = Barter.new(barter_params)
    @barter.user_id = current_user.id
    @barter.notifier_id = @notifier_id
    respond_to do |format|
      if @barter.save
         create_notification
         format.html { redirect_to search_path, notice: 'Notification sent to user' }
      else
        format.html { render action: 'new' }
        format.json { render json: @barter.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @barter = Barter.find(params[:id])
    render nothing: true
  end

  def update
    @barter = Barter.find(params[:id])
    respond_to do |format|
      if @barter.update(barter_params)
        format.html { redirect_to search_path, notice: 'Updated successfully' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @barter.errors, status: :unprocessable_entity }
      end
    end
  end  
 
  private
   # create notification for barter for first time
   # used with create method
  def create_notification
    @notification = @barter.notifications.new
    @notification.user_id = current_user.id
    @notification.notifier_id = @notifier_id 
    @notification.message = params[:message]
    @notification.target_id = @notifier_id
    @notification.save
  end
  # id is necessary of nested attributes
  # Never trust parameters from the scary internet, only allow the white list through.
  def barter_params
    params.require(:barter).permit(:country, :state, :city, :book_id, :address, :place, :exchange_item_id, 
      :exchange_items)
  end



end