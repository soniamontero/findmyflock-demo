class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  def perform(*args)
    gb = Gibbon::API.new
    gb.lists.subscribe({:id => ENV["MAILCHIMP_LIST_ID"], :email => {:email => user.email}, :double_optin => false})
  end
  end
end
