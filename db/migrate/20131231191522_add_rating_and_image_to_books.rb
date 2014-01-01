class AddRatingAndImageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :rating, :integer
    add_column :books, :image, :string
  end
end
