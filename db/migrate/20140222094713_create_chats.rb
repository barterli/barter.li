class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :msg_id
      t.timestamps
    end
  end
end
