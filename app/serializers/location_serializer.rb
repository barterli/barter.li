class LocationSerializer < ActiveModel::Serializer
  cached 
  attributes :id, :latitude, :longitude, :country, :city,
             :state, :address, :name, :id_location
  
  def cache_key
    [object, scope]
  end
end


