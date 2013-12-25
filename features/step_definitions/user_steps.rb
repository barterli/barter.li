### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_in
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end


Given(/^I am not logged in$/) do
  visit '/users/sign_out'
end

Given(/^I sign up with valid user data$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I submit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should get the current location of users$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a successful sign up message$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I sign up with an invalid data$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an invalid  message$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I sign up with facebook$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I get uid from facebook$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I sign up with twitter$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I get uid from twitter$/) do
  pending # express the regexp above with the code you wish you had
end
