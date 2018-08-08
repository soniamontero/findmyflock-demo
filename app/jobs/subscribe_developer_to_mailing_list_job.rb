class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  def perform(developer)
    gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.mailchimp[:api_key])
    gibbon.lists.subscribe({:id => Rails.application.credentials.mailchimp[:list_id], :email => {:email => developer.email}, :merge_vars => {:FNAME => developer.first_name, :LNAME => developer.last_name}, :double_optin => false})
  end
end
