require 'spec_helper'

describe Api::V1::SearchController do
  before(:each) do
    @user = FactoryGirl.create(:user) 
    @location =  FactoryGirl.create(:location)
    @location2 = Location.create(:latitude => "18.9750", :longitude=>"72.8258")
    @location3 = Location.create(:latitude => "40.6700", :longitude=>"73.9400")
    @books =  @user.books.create(:title => 'test title', :author=>'john edward',
       :location_id => @location.id)
    @books =  @user.books.create(:title => 'test title', :author=>'john edward',
       :location_id => @location2.id)
    @books =  @user.books.create(:title => 'title', :author=>'john edward',
       :location_id => @location3.id)
  end

  describe "GET search_books with authentication  " do
    it "search book by title or isbn" do
      get :search, {:search => 'test'}
      expect(response.status).to eq(200)
      expect(json).to have_key('search')
      expect(json['search'].count).to eq(2)
    end

    it "should return books even if no params are present" do
      get :search, {}
      expect(response.status).to eq(200)
      expect(json).to have_key('search')
      expect(json['search'].count).to eq(3)
    end

   it "should search books by latitude, longitude by radius" do
      get :search, {:latitude => 12.9667, :longitude => 77.5667, :radius => 1200 }
      expect(response.status).to eq(200)
      expect(json['search'].count).to eq(2)
    end

    it "should search books by latitude, longitude with default radius" do
      get :search, {:latitude => 12.9667, :longitude => 77.5667 }
      expect(response.status).to eq(200)
      expect(json['search'].count).to eq(1)
    end

    # it "should give error response if something went wrong" do
    #     Book.should_receive(:search).with(an_instance_of(Object)).and_return(false) 
    #     get :search, {:latitude => 12.9667, :longitude => 77.5667 }
    #     expect(response.status).to eq(400)
    #     expect(json).to have_key('error_code')
    #     expect(json).to have_key('error_message')
    # end

  end


end
