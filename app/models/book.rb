class Book < ActiveRecord::Base
  belongs_to :user
  before_save :change_lowercase
  has_and_belongs_to_many :tags
  validates :title, :presence => true
  validates :print, numericality: { only_integer: true }, allow_blank: true
  validates :publication_year, numericality: { only_integer: true }, allow_blank: true
  validates :edition, numericality: { only_integer: true }, allow_blank: true
  validates :value, numericality: { only_integer: true }, allow_blank: true
  mount_uploader :image, ImageUploader

  #kaminari pagination per page display
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

  #increase book visit count
  def book_visit_count()
    self.visits = self.visits.to_i + 1
    self.save
  end

  #convert title, author to lowercase
  def change_lowercase
    self.title.downcase! if self.title
    self.author.downcase! if self.author
  end

  #normal sql search
  def self.search(params)
    if params.present?
      books = Book.scoped
      books = books.where.not(user_id: params[:user_id]) if params[:user_id].present?
      books = books.where("title like ?", "%#{params[:title]}%") if params[:title].present? 
      books = books.where("author like ?", "%#{params[:author]}%") if params[:author].present?
      books = books.joins(:user).where(users: {country: params[:country]}) if params[:country].present?
      books = books.joins(:user).where(users: {city: params[:city]}) if params[:city].present?
    else
      books = Book.all.order("RAND()")
    end
    return books
   end

end
