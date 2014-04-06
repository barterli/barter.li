class UserProfileSerializer < ActiveModel::Serializer
  cached
  attributes :id, :first_name, :last_name, :id_user, :profile_image, :location

  def profile_image
  	 url = @options[:url_options]
    "#{url[:protocol]}#{url[:host]}:#{url[:port]}#{object.profile_image}"
  end

  def location
    location = object.settings.find_by(:name => "location")
    if(location.present?)
      location = Location.find(location.value)
      return location.as_json(except: [:created_at, :updated_at])
    else
      return location = nil
    end  
  end

end