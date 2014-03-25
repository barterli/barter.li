class Location < ActiveRecord::Base
  before_update :geocode_address
  has_many :books
  reverse_geocoded_by :latitude, :longitude

  # geocode address only on update and fields have changed
  def geocode_address
    return unless city_changed? || country_changed? || locality_changed?
    coords = Geocoder.coordinates(self.locality.to_s+','+self.city.to_s+','+self.country.to_s)
    if coords.kind_of?(Array)
      self.latitude = coords[0];
      self.longitude = coords[1];
    end
  end

  # address to display on maps
  def map_address
    map_address = [self.country.to_s, self.city.to_s, self.locality.to_s]
    map_address.join(",")
  end


  # foursquare api to get users near by locations
  def hangouts_full_hash
    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => 20131016)
    if(self.latitude.present? && self.longitude.present?)
      result = client.search_venues(:ll => self.latitude.to_s+','+self.longitude.to_s, :query => 'coffee')
    else
      result =  "not present"
    end
    return result
  end

  def self.set_location(params)
    location = Location.find_by(:latitude => params[:latitude], :longitude => params[:longitude])
    if(location.blank?)
      location = Location.create!(:latitude => params[:latitude], :longitude => params[:longitude], :country => params[:country], :city => params[:city], :address => params[:address], :name => params[:name])
    end
    return location
  rescue
    return false
  end

  def self.hangouts_address_by_latlng(lat, lng)
    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"], :api_version => 20131016)
    places = Array.new
    hangouts = client.search_venues(:ll => lat.to_s+','+lng.to_s, :query => 'coffee')
    if(hangouts.present? && hangouts[:venues].present?)
      hangouts[:venues].each do |hangout|
        address = hangout.location.address
        next unless address.present?
        name = hangout.name
        name = " " if name.nil? #to prevent nil to string in array push
        address = " " if address.nil? 
        places.push(name.to_s+','+address.to_s)
      end
    end
    return places
  end

end
