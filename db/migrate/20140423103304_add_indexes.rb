class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :books, :user_id, :name => 'book_user_id_ix'
  	add_index :books, :location_id, :name => 'book_location_id_ix'
  	add_index :settings, :user_id, :name => 'setting_user_id_ix'
  	add_index :locations, [:latitude, :longitude]
  end
end
