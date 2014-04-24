class UserReviewSerializer < ActiveModel::Serializer
  attributes :review_user_id, :body, :user_id

  def review_user_id
    User.find(object.review_user_id).id_user
  end

  def user_id
    User.find(object.user_id).id_user
  end

end
