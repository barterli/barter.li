require 'spec_helper'

describe BartersController do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @second_user = FactoryGirl.create(:user)  
    @book =  @second_user.books.create(:title => 'test title', :author=>'john edward')
    sign_in @user
  end

  describe "create new barter" do
    
    it "GET new" do
      get :new, {book_id: @book.id}
      assigns(:barter).should be_a(Barter)
      assigns(:book_id).should eq(@book.id.to_s)
    end

    it "Post create" do
      post :create, {message: 'sample', barter: {book_id: @book.id, city: 'bangalore', country: 'india'}}
      assigns(:barter).user_id.should eq(@user.id)
      assigns(:barter).book_id.should eq(@book.id)
      assigns(:barter).notifier_id.should eq(@second_user.id)
      assigns(:notification).user_id.should eq(@user.id)
      assigns(:notification).notifier_id.should eq(@second_user.id)
      assigns(:notification).message.should eq('sample')
    end
 
  end

  describe "update a barter" do
    
    it "GET edit" do
      @barter = FactoryGirl.create(:barter)
      get :edit, {id: @barter.id}
      assigns(:barter).should eq(@barter)
    end

    it "Put update" do
      @barter = FactoryGirl.create(:barter)
      put :update, {id: @barter.id, barter: {book_id: @barter.book_id, city: "sydney"}}
      assigns(:barter).id.should eq(@barter.id)
      assigns(:barter).city.should eq("sydney")
    end
 
  end


  
end
