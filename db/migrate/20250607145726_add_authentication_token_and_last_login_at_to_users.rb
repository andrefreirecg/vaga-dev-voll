class AddAuthenticationTokenAndLastLoginAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :authentication_token, :string
    add_index :users, :authentication_token
    add_column :users, :last_login_at, :datetime
  end
end
