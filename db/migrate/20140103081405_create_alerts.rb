class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.integer :thing_id
      t.string :thing_type
      t.boolean :is_seen
      t.string :reason_type
      t.text :message

      t.timestamps
    end
  end
end
