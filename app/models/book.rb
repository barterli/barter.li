class Book < ActiveRecord::Base
  include UniqueId
  include HabtmTouchId

  # for elasticsearch 
  include Searchable

  attr_accessor :image_cache
  belongs_to :user, touch: true
  belongs_to :location
  has_and_belongs_to_many :tags
  has_many :user_likes
  has_many :user_book_visits
  validates :title, :presence => true
  validates :location_id, :presence => true
  #validates :print, numericality: { only_integer: true }, allow_blank: true
  #validates :publication_year, numericality: { only_integer: true }, allow_blank: true
  #validates :edition, numericality: { only_integer: true }, allow_blank: true
  #validates :value, numericality: { only_integer: true }, allow_blank: true
  mount_uploader :image, ImageUploader

  # kaminari pagination per page display
  paginates_per 10


  # record the book visits by user
  def book_visit_user(user_id)
    if(user_id.present?)
      user_book_visit = UserBookVisit.new  
      user_book_visit.user_id = user_id
      user_book_visit.book_id = self.id
      user_book_visit.save
    end
  end
   
  # def as_json(options = {})
  #   super(options.merge(:methods => [:location, :tags]))
  # end
   
  # increase book visit count
  def book_visit_count()
    # using update columns for cache reasons to disable updated_at change
    self.update_columns(visits: self.visits.to_i + 1)
  end

  # convert title, author to lowercase
  def change_lowercase
    self.title.downcase! if self.title
    self.author.downcase! if self.author
  end

  def self.barter_categories
    Code[:barter_categories]
  end


  def self.read_locations_by_city(city)
    # pending
  end

 
  def location_coor
    { :lat => self.location.latitude.to_s, :lon => self.location.longitude.to_s}
  end

  # normal sql search
  def self.db_search(params)
    if params.present?
      books = Book.where(nil)
      locations = Location.near([params[:latitude], params[:longitude]], params[:radius], :units => :km) if params[:latitude].present? && params[:longitude].present? && params[:radius].present?
      # books = books.where.not(user_id: params[:user_id]) if params[:user_id].present?
      books =  books.where("title like ?", "%#{params[:title]}%") if params[:title].present? 
      # books = books.where("isbn_10 = ? or isbn_13 = ?", "#{params[:isbn]}","#{params[:isbn]}") if params[:isbn].present? 
      # books = books.where("author like ?", "%#{params[:author]}%") if params[:author].present?
      # books = books.where("author like ? or title like ?", "%#{params[:book_or_author]}%", "%#{params[:book_or_author]}%") if params[:book_or_author].present?
      locations = [] if locations.blank?
      books = books.where(:location_id => locations.map(&:id)) 
    else
      books = Book.all.order("RAND()")
    end
    return books
  end

  private
   # get cover image of book if book image is not uploaded 
   # using open library
    def save_book_cover_image
      view = Openlibrary::View
      return unless self.isbn_10.present?
      book = view.find_by_isbn(self.isbn_10)
      if(!self.image.present?)
        if book.thumbnail_url.present?
          self.remote_image_url = book.thumbnail_url 
          self.save
        end
      end
    end

end
