class AddRowOrderToStatics < ActiveRecord::Migration
  def change
    add_column :statics, :row_order, :integer
  end
end
