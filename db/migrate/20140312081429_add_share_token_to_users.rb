class AddShareTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :share_token, :string
  end
end
