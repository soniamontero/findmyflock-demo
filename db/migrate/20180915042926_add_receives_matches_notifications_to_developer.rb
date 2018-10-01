class AddReceivesMatchesNotificationsToDeveloper < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :receives_matches_notifications, :boolean, default: true
  end
end
