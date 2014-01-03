class Notifier < ActionMailer::Base
  default from: "info@barter.li"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.wish_list_book.subject
  #

  # attributes : 
  # user object, book object
  def wish_list_book(user, book)
    @user = user
    @book = book
    mail to: @user.email, subject: "Notification for wishlist"
  end
end
