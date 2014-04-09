class CreateStatics < ActiveRecord::Migration
  def change
    create_table :statics do |t|
      t.string :page_name
      t.text :body
      t.string :title

      t.timestamps
    end
  end
end
