require 'spec_helper'

describe MembersController do
  before(:each) do
    @user = FactoryGirl.create(:user) 
    sign_in @user 
  end
 
  describe "user group" do
  	it "should add user to a public group" do
  	  @group = @user.groups.create!(:title => "rails")
  	  get :join_group, :group_id => @group.id
      assigns(:member).user_id.should eq(@user.id)
      assigns(:member).group_id.should eq(@group.id)
      assigns(:member).status.should eq(Code[:membership][:approved])
    end

    it "should send request to private group" do
  	  @group = @user.groups.create!(:title => "rails", :is_private => true)
  	  Notifier.should_receive(:group_membership_request).with(@group, @user.id).and_return( double("Notifier", :deliver => true) )
  	  get :join_group, :group_id => @group.id
      assigns(:member).user_id.should eq(@user.id)
      assigns(:member).group_id.should eq(@group.id)
      assigns(:member).status.should eq(Code[:membership][:unapproved])
    end

  end

end
