class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.boolean :is_private, :default => false
      t.integer :status

      t.timestamps
    end
  end
end
