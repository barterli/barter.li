module NotificationsHelper
  def get_notify_sender_email(notification)
    user = (current_user.id == notification.notifier_id) ? notification.user_id : notification.notifier_id
    email = User.find(user).try(:email)
    email
  end

  def get_barter_book_name(barter)
    book_name = Book.find(barter.book_id).try(:title)
    book_name
  end 

  def get_notification_message(notification, length)
  	truncate(notification.message, :length => length)
  end
end

