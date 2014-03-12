class AddRegisterTypeToRegisters < ActiveRecord::Migration
  def change
    add_column :registers, :register_type, :string
  end
end
