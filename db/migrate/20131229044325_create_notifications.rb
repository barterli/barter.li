class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :notifier_id
      t.text :message
      t.integer :barter_id
      t.integer :parent_id, :default => 0

      t.timestamps
    end
  end
end
