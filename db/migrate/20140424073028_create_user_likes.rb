class CreateUserLikes < ActiveRecord::Migration
  def change
    create_table :user_likes do |t|
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
  end
end
