class CreateBarters < ActiveRecord::Migration
  def change
    create_table :barters do |t|
      t.integer :user_id
      t.integer :notifier_id
      t.integer :book_id
      t.integer :exchange_book_id
      t.string :exchange_items
      t.string :country
      t.string :state
      t.string :city
      t.string :street
      t.string :address
      t.string :place
      t.time :time
      t.date :date
      t.integer :stage, :default => 0

      t.timestamps
    end
  end
end
