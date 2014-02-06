class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :locality
      t.string :name
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
