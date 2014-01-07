class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :thing, :polymorphic => true
end
