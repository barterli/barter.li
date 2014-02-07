class AddLocationIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :location_id, :integer
  end
end
