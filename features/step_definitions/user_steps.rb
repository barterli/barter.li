### UTILITY METHODS ###

def create_visitor
  @visitor ||= {  :email => "example@example.com",
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
  @user ||= User.where(:email => "test@test.com").first
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  create_visitor
  visit '/users/sign_up'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
 
end

def sign_up_invalid_email

  visit '/users/sign_up'
  fill_in "user_email", :with => "dfdf"
  fill_in "user_password", :with => "12345678"
  fill_in "user_password_confirmation", :with => "12345678"
 
end


def sign_up_invalid_password
  
  visit '/users/sign_up'
  fill_in "user_email", :with => "sss@gmai.com"
  fill_in "user_password", :with => " "
  fill_in "user_password_confirmation", :with => "12345678"
 
end

def sign_in
  create_visitor
  visit '/users/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end


Given(/^I am not logged in$/) do
  visit '/users/sign_out'
end

Given(/^I sign up with valid user data$/) do
  sign_up
   click_button "Sign up"

end

Then(/^I should get the current location of users$/) do
 true
end

And(/^I should see a successful sign up message$/) do
  page.should have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
end

When(/^I sign up with an invalid email$/) do
  sign_up_invalid_email
  click_button "Sign up"

end

Then(/^I should see an invalid email message$/) do
  page.should have_content "errors"
end

When(/^I sign up with an invalid password$/) do
  sign_up_invalid_password
  click_button "Sign up"
end

Then(/^I should see an invalid password  message$/) do
  page.should have_content "error"
end

Given(/^I sign up with facebook$/) do
  true
end

And(/^I get uid from facebook$/) do
  true
end



#sign in feature

Given(/^I do not exist as a user or entered wrong details$/) do
  delete_user
end

When(/^I sign in with valid credentials$/) do
  sign_in
end

Then(/^I should be redirected to login page$/) do
  assert page.current_path ==  new_user_session_path 
end

And(/^I should see invalid login message$/) do
  page.should have_content "Invalid email or password."
end

Given(/^I exist as a user$/) do
  create_visitor
  @user = User.new(:email => @visitor[:email], :password => @visitor[:password])
  @user.skip_confirmation!
  @user.save

end

And(/^I should be signed in$/) do
  page.should have_content "Signed in successfully"
end


Given(/^I exist as a facebook user$/) do
  pending

end

And(/^I am not logged in with facebook$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I sign in with facebook$/) do
  
end

And(/^I should be signed in with facebook$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am disabled by admin$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I should see disabled account message$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I sign in with my email$/) do
  pending # express the regexp above with the code you wish you had
end

