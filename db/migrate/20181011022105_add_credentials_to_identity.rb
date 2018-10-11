class AddCredentialsToIdentity < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :token, :string
    add_column :identities, :expires_at, :integer
    add_column :identities, :expires, :boolean
    add_column :identities, :refresh_token, :string
  end
end
