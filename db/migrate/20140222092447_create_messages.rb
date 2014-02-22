class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :msg_from
      t.integer :msg_to
      t.string :chat_id
      t.timestamps
    end
  end
end
