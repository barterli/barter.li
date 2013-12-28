class Book < ActiveRecord::Base
  belongs_to :user
  before_save :change_lowercase
  validates :title, :presence => true
  validates :print, numericality: { only_integer: true }, allow_blank: true
  validates :publication_year, numericality: { only_integer: true }, allow_blank: true
  validates :edition, numericality: { only_integer: true }, allow_blank: true
  validates :value, numericality: { only_integer: true }, allow_blank: true
  has_and_belongs_to_many :tags


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
    self.title.downcase!
    self.author.downcase!
  end
end
