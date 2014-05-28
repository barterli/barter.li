class CreateUserReferrals < ActiveRecord::Migration
  def change
    create_table :user_referrals do |t|
      t.string :referral_id
      t.integer :user_id
      t.string :referral_token

      t.timestamps
    end
  end
end
