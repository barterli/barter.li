class NotificationsController < ApplicationController
  before_action :set_barter, except: [:user_notifications]
  before_action :authenticate_user!

  def index
    

  end

  def user_notifications
    @user_notifications = Notification.where(:target_id => current_user.id, :is_seen => false)
    @barter_notifications = Barter.where('user_id = :user_id OR notifier_id = :user_id', {user_id: current_user.id})
  end


  def new
  	@notifications = @barter.notifications
    set_notification_seen
    @notification = @barter.notifications.new
    @is_notifier = (@barter.notifier_id == current_user.id)

  end

  def create
    @notification = @barter.notifications.new(notification_params)
    @notification.notifier_id = @barter.notifier_id
    @notification.user_id = @barter.user_id
    @notification.parent_id = @barter.notifications.last.id
    target_id = (@barter.notifier_id == current_user.id) ? @barter.user_id : @barter.notifier_id 
    @notification.sent_by = current_user.id
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
   @barter = Barter.find(params[:barter_id])
  end
  
  def set_notification_seen
    unseen_notifications = @notifications.where(:target_id => current_user.id, :is_seen => false)
  	  unseen_notifications.each do |unseen_notification|
  	  unseen_notification.is_seen = true
  	  unseen_notification.save
    end
  end

  def notification_params
    params.require(:notification).permit(:notifier_id, :target_id, :user_id, :message, :parent_id)
  end

end
