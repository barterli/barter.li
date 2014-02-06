json.array!(@locations) do |location|
  json.extract! location, :id, :country, :state, :city, :locality, :name, :latitude, :longitude
  json.url location_url(location, format: :json)
end
