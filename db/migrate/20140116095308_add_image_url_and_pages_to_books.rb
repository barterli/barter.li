class AddImageUrlAndPagesToBooks < ActiveRecord::Migration
  def change
    add_column :books, :image_url, :string
    add_column :books, :pages, :integer
  end
end
