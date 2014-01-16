class AddLanguagecodeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :language_code, :string
  end
end
