class AddStatusToMembers < ActiveRecord::Migration
  def change
    add_column :members, :status, :integer
  end
end
