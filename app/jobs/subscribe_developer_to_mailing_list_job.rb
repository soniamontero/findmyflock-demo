class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  def perform(*args)
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    gibbon.lists.subscribe({:id => ENV["MAILCHIMP_LIST_ID"], :email => {:email => developer.email}, :merge_vars => {:FNAME => developer.first_name, :LNAME => developer.last_name}, :double_optin => false})
  end
end
