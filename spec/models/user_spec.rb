require 'spec_helper'

describe User do
  before(:each) do
     @attr = {
       :country => "india",
       :state => "karnataka",
       :city => "bangalore",
       :locality => "koramangala",
       :email => "test@test.com",
       :password => "12345678"
     }
   end
  
   it "should create user with latitude and longitude set with address changed on update and with address in lowercase" do
     user = User.create(@attr)
     user.city = "Bangalore"
     user.save
     user.latitude.kind_of?(Float).should be_true
     user.longitude.kind_of?(Float).should be_true
     user.city.chr.ord.should_not eq("B".chr.ord)
     user.city.chr.upcase.ord.should eq("B".chr.ord)
   end

   it "should create alerts for objects passed with type" do
     book = Book.create(:title => "rails")
     user = User.create(@attr)
     user.create_alert(book, "W")
     alert = Alert.last
     alert.thing_type.should eq("Book")
     alert.thing_id.should eq(book.id)
     alert.reason_type.should eq("W")
  end

  it "should get near by hangouts of user address using foursquare api" do
     user = User.create(@attr)
     user.city = "Bangalore"
     user.save
     hangouts = user.near_by_hangouts
     hangouts.kind_of?(Hash).should be_true
  end

  it "should give default email per month count" do
     user = User.create(@attr)
     DefaultSetting.create_setting("email_per_month", 10)
     user.setting_email_count_month.should eq(10)
  end

  it "should give mail duration" do
     user = User.create(@attr)
     user.mail_duration(Time.now).should eq(0)
  end

  it "should create email track" do
     user = User.create(@attr)
     user.save_email_track("W")
     track = user.email_tracks.last
     track.sent_for.should eq("W")
  end

   it "should give user address joind by comma" do
     user = User.create(@attr)
     address = user.map_address
     address.should eq("india,bangalore,koramangala")
  end

   it "should give mails by month" do
     user = User.create(@attr)
     book = Book.create(:title => "rails")
     DefaultSetting.create_setting("email_duration", 0)
     DefaultSetting.create_setting("email_per_month", 10)
     user.mail_wish_list(book, "wishlist")
     user.mail_wish_list(book, "wishlist")
     user.mails_by_month(Time.now.month).count.should eq(2)
  end

  it "should give users email per month count if user sets it" do
     user = User.create(@attr)
     DefaultSetting.create_setting("email_per_month", 10)
     user.settings.create(:name => "email_per_month", :value => 12)
     user.setting_email_count_month.should eq(12)
  end


  it "should give default email duration" do
     user = User.create(@attr)
     DefaultSetting.create_setting("email_duration", 2)
     user.setting_email_duration.should eq(2)
  end

  it "should give users email per month count if user sets it" do
     user = User.create(@attr)
     DefaultSetting.create_setting("email_duration", 10)
     user.settings.create(:name => "email_duration", :value => 12)
     user.setting_email_duration.should eq(12)
  end

  it "Should send wishlist mail according to user mailer settings" do
    user = User.create(@attr) 
    book = Book.create(:title => "rails")
    DefaultSetting.create_setting("email_per_month", 1)
    Notifier.should_receive(:wish_list_book).with(user, book).and_return( double("Notifier", :deliver => true) )
    user.mail_wish_list(book, "wishlist")
    mails_by_month = user.mails_by_month(Time.now.month)
    email_tracks = user.email_tracks.last
    mails_by_month.count.should eq(1)
    email_tracks.sent_for.should eq(Code[:wish_list_book])
  end

  it "Should not send wishlist mail if no of mails excedes default setting" do
    user = User.create(@attr) 
    book = Book.create(:title => "rails")
    DefaultSetting.create_setting("email_per_month", 1)
    DefaultSetting.create_setting("email_duration", 0)
    Notifier.should_receive(:wish_list_book).with(user, book).and_return( double("Notifier", :deliver => true) )
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    mails_by_month = user.mails_by_month(Time.now.month)
    email_tracks = user.email_tracks.last
    mails_by_month.count.should eq(1)
    email_tracks.sent_for.should eq(Code[:wish_list_book])
  end

   it "Should not send wishlist mail if default  mail duration exceeds" do
    user = User.create(@attr) 
    book = Book.create(:title => "rails")
    DefaultSetting.create_setting("email_per_month", 2)
    DefaultSetting.create_setting("email_duration", 1)
    Notifier.should_receive(:wish_list_book).with(user, book).and_return( double("Notifier", :deliver => true) )
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    mails_by_month = user.mails_by_month(Time.now.month)
    email_tracks = user.email_tracks.last
    mails_by_month.count.should eq(1)
    email_tracks.sent_for.should eq(Code[:wish_list_book])
  end

   it "Should not send wishlist mail if no of mails excedes user setting" do
    user = User.create(@attr) 
    book = Book.create(:title => "rails")
    DefaultSetting.create_setting("email_per_month", 5)
    DefaultSetting.create_setting("email_duration", 0)
    user.settings.create(:name => "email_duration", :value => 0)
    user.settings.create(:name => "email_per_month", :value => 2)
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    mails_by_month = user.mails_by_month(Time.now.month)
    email_tracks = user.email_tracks.last
    mails_by_month.count.should eq(2)
    email_tracks.sent_for.should eq(Code[:wish_list_book])
  end

   it "Should not send wishlist mail if user setting mail duration exceeds" do
    user = User.create(@attr) 
    book = Book.create(:title => "rails")
    DefaultSetting.create_setting("email_per_month", 2)
    DefaultSetting.create_setting("email_duration", 1)
    user.settings.create(:name => "email_duration", :value => 1)
    user.settings.create(:name => "email_per_month", :value => 5)
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    user.mail_wish_list(book, "wishlist")
    mails_by_month = user.mails_by_month(Time.now.month)
    email_tracks = user.email_tracks.last
    mails_by_month.count.should eq(1)
    email_tracks.sent_for.should eq(Code[:wish_list_book])
  end

end
