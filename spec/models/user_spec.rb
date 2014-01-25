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

  it "should give users email per month count if user sets it" do
     user = User.create(@attr)
     DefaultSetting.create_setting("email_per_month", 10)
     user.settings.create(:name => "email_per_month", :value => 12)
     user.setting_email_count_month.should eq(12)
  end

end
