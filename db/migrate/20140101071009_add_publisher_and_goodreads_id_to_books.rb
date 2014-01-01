class AddPublisherAndGoodreadsIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :publisher, :string
    add_column :books, :goodreads_id, :string
  end
end
