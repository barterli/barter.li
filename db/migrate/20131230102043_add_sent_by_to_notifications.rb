class AddSentByToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :sent_by, :integer
  end
end
