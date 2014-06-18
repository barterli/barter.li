class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :code
      t.string :code_type
      t.boolean :current, default: false

      t.timestamps
    end
  end
end
