class CreateUserReviews < ActiveRecord::Migration
  def change
    create_table :user_reviews do |t|
      t.integer :user_id
      t.text :body
      t.string :moderate
      t.integer :stars

      t.timestamps
    end
  end
end
