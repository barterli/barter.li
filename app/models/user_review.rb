class UserReview < ActiveRecord::Base
  validates :review_user_id, :user_id, :body, presence: true
end
