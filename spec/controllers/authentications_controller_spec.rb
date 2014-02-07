require 'spec_helper'

describe AuthenticationsController do

  describe "POST create_user" do
    describe "with valid params" do
      it "creates a new user" do
        expect {
          post :create_user, {:format => 'json', :email => "test@gmail.com", :uid => 3234234}
        }.to change(User, :count).by(1)
      end
       it "response should contain status success with valid params" do
          post :create_user, {:format => 'json', :email => "test@gmail.com", :uid => 3234234}
          JSON.parse(response.body)["status"].should eq("success")
      end 
       it "response should contain status error with inavalid params" do
          post :create_user, {:format => 'json', :email => "tesmail.com", :uid => 3234234}
          JSON.parse(response.body)["status"].should eq("error")
      end       
    end
  end
end
