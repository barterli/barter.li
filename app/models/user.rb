class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :change_lowercase
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  has_many :books
  


  def change_lowercase
    self.country.downcase! if self.country
    self.state.downcase! if self.state
    self.city.downcase! if self.city
    self.street.downcase! if self.street
    self.locality.downcase! if self.locality
  end
end
