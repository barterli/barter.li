class Book < ActiveRecord::Base
  belongs_to :user
  validates :title, :presence => true
  validates :print, numericality: { only_integer: true }, allow_blank: true
  validates :publication_year, numericality: { only_integer: true }, allow_blank: true
  validates :edition, numericality: { only_integer: true }, allow_blank: true
  validates :value, numericality: { only_integer: true }, allow_blank: true
  has_and_belongs_to_many :tags
end
