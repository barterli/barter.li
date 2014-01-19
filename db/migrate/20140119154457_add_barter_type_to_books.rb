class AddBarterTypeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :barter_type, :string
  end
end
