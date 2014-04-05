class AddBodyToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :body, :text
  end
end
