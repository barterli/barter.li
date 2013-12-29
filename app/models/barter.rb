class Barter < ActiveRecord::Base
  has_many :notifications
  accepts_nested_attributes_for :notifications
  
end
