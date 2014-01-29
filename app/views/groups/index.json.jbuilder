json.array!(@groups) do |group|
  json.extract! group, :id, :user_id, :title, :description, :is_private, :status
  json.url group_url(group, format: :json)
end
