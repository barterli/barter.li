require 'spec_helper'

describe UsersController do
  
  before(:each) do
    @user = FactoryGirl.create(:user) 
    sign_in @user 
  end

  describe "edit profile" do
   
    it "GET edit profile" do
      get :edit_profile, {}
      assigns(:user).should eq(@user)
    end
    
    it "UPDATE profile" do
      post :update_profile, {user: {country: 'britain'}}
      assigns(:current_user).country.should eq('britain')
    end

  end

  describe "user reviews" do
   
    it "create user reviews" do
      post :create_user_review, {user_review: {body: 'sample', user_id: 1}}
      assigns(:user_review).body.should eq('sample')
      assigns(:user_review).user_id.should eq(1)
    end
  
  end

end
