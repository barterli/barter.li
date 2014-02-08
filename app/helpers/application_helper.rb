module ApplicationHelper
  def user_notifications
    user_notifications = Notification.where(:target_id => current_user.id, :is_seen => false)
    if(user_notifications.present?)
      return user_notifications.count
    else
      return 0
    end
  end

  def user_location
    return "" if current_user.blank?
    location = current_user.settings.where(name: 'location').first
    return "" if location.blank?
    location = Location.find(location.value)
    return "#{location.city},#{location.country}"
  end
end
