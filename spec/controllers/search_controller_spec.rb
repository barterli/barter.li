require 'spec_helper'

describe SearchController do
  before(:each) do
    @user = FactoryGirl.create(:user)  
    @books =  @user.books.create(:title => 'test title', :author=>'john edward')
  end

  describe "GET search_books without authentication " do
    it "search book by title" do
      get :search_books, {:search => { :title => 'test'} }
      assigns(:books).should eq([@books])
    end
  
   it "search book by author" do
      get :search_books, {:search => { :author => 'john'} }
      assigns(:books).should eq([@books])
    end
  
   it "search book by location" do
      get :search_books, {:search => { :city => 'bangalore'} }
      assigns(:books).should eq([@books])
    end
  
 end

 describe "GET search_books without authentication  " do
    it "search book by title and returns empty if not present" do
      get :search_books, {:search => { :title => 'bbbb'} }
      assigns(:books).should eq([])
    end
  
   it "search book by author and returns empty if not present" do
      get :search_books, {:search => { :author => 'vvvv'} }
      assigns(:books).should eq([])
    end
  
   it "search book by location and returns empty if not present" do
      get :search_books, {:search => { :city => 'cccc'} }
      assigns(:books).should eq([])
    end
  
  end

  describe "GET search_books with authentication  " do

    it "search book by title and should not show books created by user" do
     sign_in @user
      get :search_books, {:search => { :title => 'test'} }
      assigns(:books).should eq([])
    end
  
   it "search book by author and and should not show books created by user" do
      sign_in @user
      get :search_books, {:search => { :author => 'john'} }
      assigns(:books).should eq([])
    end
  
   it "search book by location and and should not show books created by user" do
      sign_in @user
      get :search_books, {:search => { :city => 'bangalore'} }
      assigns(:books).should eq([])
    end
  
  end

end
