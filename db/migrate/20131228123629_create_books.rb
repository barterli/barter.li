class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn_10
      t.string :isbn_13
      t.integer :edition
      t.integer :print
      t.integer :publication_year
      t.string :publication_month
      t.string :condition
      t.integer :value
      t.boolean :status
      t.integer :stage
      t.text :description
      t.integer :visits
      t.integer :user_id
      t.string :prefered_place
      t.string :prefered_time

      t.timestamps
    end
  end
end
