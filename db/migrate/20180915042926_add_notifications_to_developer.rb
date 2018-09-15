class AddNotificationsToDeveloper < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :notifications, :boolean, default: true
  end
end
