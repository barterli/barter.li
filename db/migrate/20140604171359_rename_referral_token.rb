class RenameReferralToken < ActiveRecord::Migration
  def change
  	rename_column :user_referrals, :referral_token, :device_id
  end
end
