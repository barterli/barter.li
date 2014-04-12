class BookSerializer < ActiveModel::Serializer
  cached 
  attributes :id, :title, :author, :publication_year, :publication_month, 
             :image_url, :barter_type, :location, :tags, :id_book, :description, :isbn_10, :isbn_13, :id_user
  
  def location
    object.location.as_json(except: [:created_at, :updated_at])
  end

  def tags
    object.tags.map(&:name)
  end

  def id_user
    object.user.id_user
  end

  def image_url
  	url = @options[:url_options]
  	#return  ActionController::Base.helpers.asset_url(object.image.url)if object.image_url.present?
    return object.ext_image_url unless object.image.url.present?
    "#{url[:protocol]}#{url[:host]}:#{url[:port]}#{object.image.url}"
  end

  def cache_key
    [object, scope]
  end

end

    # t.string   "title"
    # t.string   "author"
    # t.string   "isbn_10"
    # t.string   "isbn_13"
    # t.string   "edition"
    # t.integer  "print"
    # t.integer  "publication_year"
    # t.string   "publication_month"
    # t.string   "condition"
    # t.integer  "value"
    # t.boolean  "status"
    # t.integer  "stage"
    # t.text     "description"
    # t.integer  "visits"
    # t.integer  "user_id"
    # t.string   "prefered_place"
    # t.string   "prefered_time"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.integer  "rating"
    # t.string   "image"
    # t.string   "publisher"
    # t.string   "goodreads_id"
    # t.string   "image_url"
    # t.integer  "pages"
    # t.string   "language_code"
    # t.string   "barter_type"
    # t.integer  "location_id"