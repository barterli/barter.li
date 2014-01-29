require 'spec_helper'


describe GroupsController do
  
  let(:valid_attributes) { { :title => "rails"} }
  
  before(:each) do
    @user = FactoryGirl.create(:user) 
    sign_in @user 
    @group = @user.groups.create(:title => "rails")
  end

  describe "GET index" do
    it "assigns all groups as @groups" do
      group = @user.groups
      get :index, {}
      assigns(:groups).should eq(group)
    end
  end

  describe "GET show" do
    it "assigns the requested group as @group" do
      group = @group
      get :show, {:id => @group.to_param}
      assigns(:group).should eq(group)
    end
  end

  describe "GET new" do
    it "assigns a new group as @group" do
      get :new, {}
      assigns(:group).should be_a_new(Group)
    end
  end

  describe "GET edit" do
    it "assigns the requested group as @group" do
      group = @group
      get :edit, {:id => group.to_param}
      assigns(:group).should eq(group)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Group" do
        expect {
          post :create, {:group => valid_attributes}
        }.to change(Group, :count).by(1)
      end

      it "assigns a newly created group as @group" do
        post :create, {:group => valid_attributes}
        assigns(:group).should be_a(Group)
        assigns(:group).should be_persisted
      end

      it "redirects to the created group" do
        post :create, {:group => valid_attributes}
        response.should redirect_to(Group.last)
      end
    end


    describe "with invalid params" do
      it "assigns a newly created but unsaved group as @group" do
        # Trigger the behavior that occurs when invalid params are submitted
        Group.any_instance.stub(:save).and_return(false)
        post :create, {:group => { "user_id" => "invalid value" }}
        assigns(:group).should be_a_new(Group)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Group.any_instance.stub(:save).and_return(false)
        post :create, {:group => { "user_id" => "invalid value" }}
        response.should render_template("new")
      end
    end
   end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested group" do
        group = @user.groups.create! valid_attributes
        # Assuming there are no other groups in the database, this
        # specifies that the Group created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Group.any_instance.should_receive(:update).with({ "title" => "rr" })
        put :update, {:id => group.to_param, :group => { "title" => "rr" }}
      end

      it "assigns the requested group as @group" do
        group = @user.groups.create! valid_attributes
        put :update, {:id => group.to_param, :group => valid_attributes}
        assigns(:group).should eq(group)
      end

      it "redirects to the group" do
        group = @user.groups.create! valid_attributes
        put :update, {:id => group.to_param, :group => valid_attributes}
        response.should redirect_to(group)
      end
    end

    describe "with invalid params" do
      it "assigns the group as @group" do
        group = @user.groups.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Group.any_instance.stub(:save).and_return(false)
        put :update, {:id => group.to_param, :group => { "title" => "invalid value" }}
        assigns(:group).should eq(group)
      end

      it "re-renders the 'edit' template" do
        group = @user.groups.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Group.any_instance.stub(:save).and_return(false)
        put :update, {:id => group.to_param, :group => { "title" => "invalid value" }}
        response.should render_template("edit")
      end
    end
  end

  describe "gets members of the group" do
    it "assign members of the group as @members" do
      @members = @group.members.create!(:user_id => 1)  
      @members = @group.members
      get :manage_members, {:id => @group.id}
      assigns(:members).should eq(@members)
    end

   it "assign unapproved members of the group as @members" do
      @group.members.create!(:user_id => 1, :status => Code[:membership][:unapproved])
      @group.members.create!(:user_id => 2, :status => Code[:membership][:approved])  
      @members = @group.members.where(:status => Code[:membership][:unapproved])
      get :membership_approval, {:id => @group.id}
      assigns(:members).should eq(@members)
    end

  end 


  # describe "DELETE destroy" do
  #   it "destroys the requested group" do
  #     group = Group.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => group.to_param}
  #     }.to change(Group, :count).by(-1)
  #   end

  #   it "redirects to the groups list" do
  #     group = Group.create! valid_attributes
  #     delete :destroy, {:id => group.to_param}
  #     response.should redirect_to(groups_url)
  #   end
  # end

end
