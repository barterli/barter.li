class CreateUserBookVisits < ActiveRecord::Migration
  def change
    create_table :user_book_visits do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :time_spent
      t.integer :count

      t.timestamps
    end
  end
end
