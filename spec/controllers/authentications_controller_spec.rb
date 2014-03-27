require 'spec_helper'
describe Api::V1::AuthenticationsController do

  describe "POST create_user" do
    describe "with valid params" do
       it "creates a new user with provider manual" do
          post :create_user, {:format => 'json', :email => "test@gmail.com", :password => "3234234n6", :provider => "manual"}
          expect(response.status).to eq(200)
          expect(json).to have_key('user')
      end 
      it "gives the existing user if already present" do
          post :create_user, {:format => 'json', :email => "test@gmail.com", :password => "3234234n6", :provider => "manual"}
          expect(response.status).to eq(200)
          expect(json).to have_key('user')
          expect(User.count).to eq(1)
      end 
    end
    describe "with invalid params" do
       it "response should contain status error with inavalid params with manual" do
          post :create_user, {:format => 'json', :email => "tesmail.com", :password => 3234234, :provider => "manual"}
          expect(response.status).to eq(400)
          expect(json).to have_key('error_code')
          expect(json).to have_key('error_message')
      end
    end
  end
end

