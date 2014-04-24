class UserFeedback < ActiveRecord::Base
  belongs_to :user
  # validates :title, :label, :body, presence: true
end
