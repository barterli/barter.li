json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :group_id, :body, :title, :publish_type, :status
  json.url post_url(post, format: :json)
end
