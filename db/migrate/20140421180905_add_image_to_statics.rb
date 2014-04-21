class AddImageToStatics < ActiveRecord::Migration
  def change
    add_column :statics, :image, :string
  end
end
