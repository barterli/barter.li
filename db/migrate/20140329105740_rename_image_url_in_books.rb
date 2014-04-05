class RenameImageUrlInBooks < ActiveRecord::Migration
  def change
  	rename_column :books, :image_url, :ext_image_url
  end
end
