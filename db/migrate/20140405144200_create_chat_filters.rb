class CreateChatFilters < ActiveRecord::Migration
  def change
    create_table :chat_filters do |t|
      t.integer :user_id
      t.integer :block_id

      t.timestamps
    end
  end
end
