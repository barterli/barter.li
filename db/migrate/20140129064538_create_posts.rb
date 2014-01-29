class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :group_id
      t.text :body
      t.string :title
      t.integer :publish_type
      t.integer :status

      t.timestamps
    end
  end
end
