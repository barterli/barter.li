class CreateChatGroups < ActiveRecord::Migration
  def change
    create_table :chat_groups do |t|
      t.integer :user_id
      t.integer :chat_id

      t.timestamps
    end
  end
end
