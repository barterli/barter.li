class CreateEmailTracks < ActiveRecord::Migration
  def change
    create_table :email_tracks do |t|
      t.integer :user_id
      t.string :sent_for
      t.date :date

      t.timestamps
    end
  end
end
