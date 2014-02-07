require 'spec_helper'

describe Location do
  before(:each) do
     @attr = {
       :country => "india",
       :city => "bangalore",
       :locality => "koramangala"
     }
   end
 

  it "should give location address joind by comma" do
     location = Location.create(@attr)
     address = location.map_address
     address.should eq("india,bangalore,koramangala")
  end

 it "should get near by hangouts of user address using foursquare api" do
     location = Location.create(@attr)
     location.city = "Bangalore"
     location.save
     hangouts = location.hangouts_full_hash
     hangouts.kind_of?(Hash).should be_true
  end

 it "should get  hangouts if lat lng is given using foursquare api" do
     location = Location.create(@attr)
     location.city = "Bangalore"
     location.save
     hangouts = Location.hangouts_address_by_latlng(location.latitude, location.longitude)
     hangouts.kind_of?(Array).should be_true
     hangouts.count.should be >= 1
  end

end





