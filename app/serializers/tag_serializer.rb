class TagSerializer < ActiveModel::Serializer
  cached
  attributes :id, :name

  def cache_key
    [object, scope]
  end

end
