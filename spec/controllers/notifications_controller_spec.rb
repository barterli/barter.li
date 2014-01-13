require 'spec_helper'

describe NotificationsController do
  before(:each) do
    @user = FactoryGirl.create(:user) 
    @second_user = FactoryGirl.create(:user) 
    @book =  @user.books.create(:title => 'test title', :author=>'john edward')
    @second_book =  @second_user.books.create(:title => 'second title', :author=>'elvin edward')
    @barter = Barter.create(user_id: @user.id, notifier_id: @second_user.id, exchange_book_id: @second_book.id, book_id: @book.id)
    @notification = @barter.notifications.create(user_id: @user.id, notifier_id: @second_user.id, target_id: @second_user.id, message: "sample message", parent_id: 0, sent_by: @user.id )
    
  end


  describe "get user notifications and unseen notifications" do
    it "GET users notifications receiver gets user notification" do
      sign_in @second_user
      get :user_notifications
      assigns(:user_notifications).should eq([Notification.first])
      assigns(:barter_notifications).should eq([@barter])
    end
  
   it "GET users notifications sender user notification is empty" do
      sign_in @user
      get :user_notifications
      assigns(:user_notifications).should eq([])
      assigns(:barter_notifications).should eq([@barter])
    end
  
 end

  describe "post create new user notification" do
    it "creates a new user notification " do
      sign_in @second_user
      post :create, {barter_id: @barter.id, notification: {message: 'test'}}
      assigns(:notification).target_id.should eq(@user.id)
      assigns(:notification).sent_by.should eq(@second_user.id)
      assigns(:notification).parent_id.should eq(@notification.id)
    end
  
  end

  describe "new notification" do
    it "sets the notification as seen" do
      sign_in @second_user
      get :new, {barter_id: @barter.id}
      @barter.notifications.first.is_seen.should eq(true)
      assigns(:notification).should be_a(Notification)
      assigns(:is_notifier).should eq(true)
    end
  
  end

 
end
