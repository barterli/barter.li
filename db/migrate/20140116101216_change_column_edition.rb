class ChangeColumnEdition < ActiveRecord::Migration
  def up
  	change_column :books, :edition, :string
  end

  def down
   change_column :books, :edition, :integer
  end
end
