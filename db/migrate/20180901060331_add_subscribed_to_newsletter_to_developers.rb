class AddSubscribedToNewsletterToDevelopers < ActiveRecord::Migration[5.2]
  def change
    add_column :developers, :subscribed_to_newsletter, :boolean
  end
end
