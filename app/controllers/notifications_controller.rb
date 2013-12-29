class NotificationsController < ApplicationController
  before_action :set_barter

  def new
    @notification = @barter.notifications.new
  end

  def create
    @notification = @barter.notifications.new(notification_params)
    target_id = params[:notification][:notifier_id] == current_user.id ? params[:notification][:user_id] : params[:notification][:notifier_id] 
    @notification.target_id = target_id
    respond_to do |format|
      if @notification.save
        format.html { redirect_to search_path, notice: 'Notification sent to user' }
      else
        format.html { render action: 'new' }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end
 
  private
  
  def set_barter
   @barter = Barter.find(params[:id])
  end

  def notification_params
    params.require(:notifications).permit(:notifier_id, :target_id, :user_id, :message, :parent_id)
  end

end
