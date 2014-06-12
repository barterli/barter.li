class BookSerializer < ActiveModel::Serializer
  cached 
  attributes :id, :title, :author, :publication_year, :publication_month, :value,
             :image_url, :barter_type, :location, :tags, :id_book, :description, :isbn_10, :isbn_13, :id_user,
             :owner_name, :owner_image_url, :image_present
  
  def location
    object.location.as_json(except: [:created_at, :updated_at])
  end

  def tags
    object.tags.map(&:name)
  end

  def id_user
    @user ||= user
    @user.id_user
  end

  def owner_name
    @user ||= user
    @user.first_name.to_s + " " + @user.last_name.to_s
  end

  def image_present
    if object.ext_image_url.present? &&  !object.ext_image_url.index("nocover")
      return true
    else
      return false
    end
  end

  def owner_image_url
    @user ||= user
    url = @options[:url_options]
    port = url[:port].present? ?  ":"+url[:port].to_s: ""
    @user.absolute_profile_image("http://#{url[:host]}#{port}")
  end

  def image_url
  	url = @options[:url_options]
    return object.ext_image_url if object.image.url.index("default") && object.ext_image_url.present? &&  !object.ext_image_url.index("nocover")
    port = url[:port].present? ?  ":"+url[:port].to_s: ""
    image_path = ActionController::Base.helpers.asset_path(object.image.url)
    "#{url[:protocol]}#{url[:host]}#{port}#{image_path}"
  end

  def cache_key
    [object, scope]
  end

  def user
    @user = object.user
  end

end

