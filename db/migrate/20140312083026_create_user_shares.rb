class CreateUserShares < ActiveRecord::Migration
  def change
    create_table :user_shares do |t|
      t.integer :user_id
      t.integer :shared_user_id

      t.timestamps
    end
  end
end
