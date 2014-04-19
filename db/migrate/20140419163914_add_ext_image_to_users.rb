class AddExtImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ext_image, :string
  end
end
