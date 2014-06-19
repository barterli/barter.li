class AddDeviceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_id, :string
  end
end
