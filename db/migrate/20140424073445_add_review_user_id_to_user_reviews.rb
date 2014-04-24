class AddReviewUserIdToUserReviews < ActiveRecord::Migration
  def change
    add_column :user_reviews, :review_user_id, :integer
  end
end
