class UserSerializer < ActiveModel::Serializer
  cached
  attributes :email, :description, :first_name, :last_name, :location, 
  :auth_token, :sign_in_count, :id_user, :image_url, :share_token, 
  :referral_count, :book_referral_count
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
    # return object.ext_image if object.ext_image.present?
    url = @options[:url_options]
    port = url[:port].present? ?  ":"+url[:port].to_s: ""
    object.absolute_profile_image("http://#{url[:host]}#{port}")
  end

  def referral_count
    object.user_referrals.count
  end
    
  def cache_key
    [object, scope]
  end

  def book_referral_count
    users_by_referral = object.referrals
    if users_by_referral.present?
      user_ids = users_by_referral.map{|u| u.id}
      book_count = Book.where(user_id: user_ids).count
      return book_count
    else
      return 0
    end
  end

end


