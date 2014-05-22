class UserProfileSerializer < ActiveModel::Serializer
  cached
  attributes :first_name, :last_name, :id_user, :location, :image_url, :description
  has_many :books

  def profile_image
  	 url = @options[:url_options]
    "#{url[:protocol]}#{url[:host]}:#{url[:port]}#{object.profile_image}"
  end

  def image_url
    return object.ext_image if object.ext_image.present?
    url = @options[:url_options]
    port = url[:port].present? ?  ":"+url[:port].to_s: ""
    object.absolute_profile_image("#{url[:host]}#{port}")
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

  def cache_key
    [object, scope]
  end

end