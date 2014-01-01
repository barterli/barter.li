class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :change_lowercase
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  has_many :books
  before_update :geocode_address

  def change_lowercase
    self.country.downcase! if self.country
    self.state.downcase! if self.state
    self.city.downcase! if self.city
    self.street.downcase! if self.street
    self.locality.downcase! if self.locality
  end

  #foursquare api to get users near by locations
  def near_by_hangouts
    client = Foursquare2::Client.new(:client_id => ENV["FOURSQUARE_CLIENT_ID"], :client_secret => ENV["FOURSQUARE_CLIENT_SECRET"])
    if(self.latitude.present? && self.longitude.present?)
      return client.search_venues(:ll => self.latitude+','+self.longitude, :query => 'coffee')
    else
      return " "
    end
  end
  
  #geocode address only on update and fields have changed
  def geocode_address
    return unless street_changed? || city_changed? || country_changed? || locality_changed? || state_changed?
    coords = Geocoder.coordinates(self.street.to_s+","+self.locality.to_s+','+self.city.to_s+','+self.country.to_s)
    if coords.kind_of?(Array)
      self.latitude = coords[0];
      self.longitude = coords[1];
    end
  end

end
