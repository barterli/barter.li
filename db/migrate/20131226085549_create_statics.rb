class CreateStatics < ActiveRecord::Migration
  def change
    create_table :statics do |t|
      t.string :title
      t.text :body
      t.boolean :status
      t.string :page_name

      t.timestamps
    end
  end
end
