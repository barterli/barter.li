class Static < ActiveRecord::Base
  serialize :body, Hash
end
