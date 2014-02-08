require 'digest/sha2'
class Notifier < ActionMailer::Base
  default from: "info@barter.li"
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@barter.li"


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

  def group_membership_request(group, member_id)
    @user = User.find(member_id)
    @group = group
    mail to: @group.user.email, subject: "Membership Request"
  end

  def barter_request(owner,user,book,message)
    @user = user
    @owner = owner
    @book = book
    @message = message
    mail to: @user.email, subject: "Barter.li request for book"
  end

end
