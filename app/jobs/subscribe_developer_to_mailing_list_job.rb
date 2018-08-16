require 'digest'

class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  def perform(developer)
    member_id = Digest::MD5.new.update(developer.email.downcase).hexdigest
    list_id = Rails.application.credentials.mailchimp[:list_id]
    mailchimp_api_key = Rails.application.credentials.mailchimp[:api_key]
    merge_fields = {}
    merge_fields[:FNAME] = developer.first_name if developer.first_name.present?
    merge_fields[:LNAME] = developer.last_name if developer.last_name.present?
    gibbon = Gibbon::Request.new(api_key: mailchimp_api_key)
    gibbon.lists(list_id)
          .members(member_id)
          .upsert(body: {
            email_address: developer.email,
            status_if_new: "subscribed",
            merge_fields: merge_fields,
          })
  end
end
