class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.integer :user_id
      t.integer :issue_id
      t.string :issue_url
      t.text :message
      t.string :title
      t.string :label

      t.timestamps
    end
  end
end
