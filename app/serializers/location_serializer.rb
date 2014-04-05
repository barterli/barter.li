class LocationSerializer < ActiveModel::Serializer
  cached 
  attributes :id, :latitude, :longitude, :country, :city,
             :state, :address, :name, :id_location
  
  def cache_key
    [object, scope]
  end
end


   # t.string   "country"
   #  t.string   "state"
   #  t.string   "city"
   #  t.string   "address"
   #  t.string   "postal_code"
   #  t.string   "locality"
   #  t.string   "name"
   #  t.string   "latitude"
   #  t.string   "longitude"
   #  t.datetime "created_at"
   #  t.datetime "updated_at"