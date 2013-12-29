module ApplicationHelper
  def user_notifications
    user_notifications = Notification.where(:target_id => current_user.id, :is_seen => false)
    if(user_notifications.present?)
      return user_notifications.count
    else
      return 0
    end
  end
end
