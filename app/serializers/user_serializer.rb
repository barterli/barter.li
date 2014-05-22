class UserSerializer < ActiveModel::Serializer
  cached
  attributes :email, :description, :first_name, :last_name, :location, 
  :auth_token, :sign_in_count, :id_user, :image_url
  has_many :books
 
  def location
    location = object.settings.find_by(:name => "location")
    if(location.present?)
      location = Location.find(location.value)
      return location.as_json(except: [:created_at, :updated_at])
    else
      return location = nil
    end  
  end

  def auth_token
    object.authentication_token
  end

  def image_url
    return object.ext_image if object.ext_image.present?
    url = @options[:url_options]
    port = url[:port].present? ?  ":"+url[:port].to_s: ""
    object.absolute_profile_image("#{url[:host]}#{port}")
  end
    
  def cache_key
    [object, scope]
  end

end


