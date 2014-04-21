class Static < ActiveRecord::Base
  serialize :body, Hash
  mount_uploader :image, ImageUploader

end
