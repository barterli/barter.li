class CreateWishLists < ActiveRecord::Migration
  def change
    create_table :wish_lists do |t|
      t.integer :user_id
      t.string :title
      t.string :author
      t.boolean :in_locality, :default => false
      t.boolean :in_city, :default => true

      t.timestamps
    end
  end
end
