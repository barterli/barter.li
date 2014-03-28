require 'spec_helper'

describe Api::V1::UsersController do
  
  before(:each) do
    @user = FactoryGirl.create(:user) 
    # http_login(@user.authentication_token, @user.email)
  end

   describe "GET user profile" do
     it "give user profile by id" do
       @user2 = FactoryGirl.create(:user) 
       get :user_profile, {:id => @user2.id }
       expect(response.status).to eq(200)
       expect(json).to have_key('user')
     end
     it "give current user profile" do
       http_login(@user.authentication_token, @user.email)
       @user2 = FactoryGirl.create(:user) 
       get :show, {}
       expect(response.status).to eq(200)
       expect(json).to have_key('user')
     end
   end

   describe "user preferred location" do
     it "should set user preferred location" do
     http_login(@user.authentication_token, @user.email)
     post :set_user_preferred_location, {:latitude => 12.23, :longitude => 13.123}
     expect(response.status).to eq(200)
     expect(json).to have_key('location')
     end
     it "should get user preferred location" do
       http_login(@user.authentication_token, @user.email)
       post :get_user_preferred_location, {}
       expect(response.status).to eq(200)
       expect(json).to have_key('location')
     end
   end

  # describe "update profile" do
   
  #   it "GET edit profile" do
  #     get :edit_profile, {}
  #     assigns(:user).should eq(@user)
  #   end
    
  #   it "UPDATE profile" do
  #     post :update_profile, {user: {country: 'britain'}}
  #     assigns(:current_user).country.should eq('britain')
  #   end

  # end

  # describe "user reviews" do
   
  #   it "create user reviews" do
  #     post :create_user_review, {user_review: {body: 'sample', user_id: 1}}
  #     assigns(:user_review).body.should eq('sample')
  #     assigns(:user_review).user_id.should eq(1)
  #   end
  
  # end

end
