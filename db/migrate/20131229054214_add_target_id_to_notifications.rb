class AddTargetIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :target_id, :integer
  end
end
