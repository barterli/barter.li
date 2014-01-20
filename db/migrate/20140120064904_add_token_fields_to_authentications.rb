class AddTokenFieldsToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :token, :string
    add_column :authentications, :token_secret, :string
  end
end
