class AddFoursquareIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :foursquare_id, :string
  end
end
