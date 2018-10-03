class AddOmniauthToDevelopers < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :provider, :string
    add_column :developers, :uid, :string
    add_column :developers, :token, :string
    add_column :developers, :expires_at, :integer
    add_column :developers, :expires, :boolean
    add_column :developers, :refresh_token, :string
  end
end
