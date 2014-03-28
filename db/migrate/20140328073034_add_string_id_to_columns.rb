class AddStringIdToColumns < ActiveRecord::Migration
  def change
    add_column :users, :id_user, :string
    add_column :books, :id_book, :string
    add_column :locations, :id_location, :string
  end
end
