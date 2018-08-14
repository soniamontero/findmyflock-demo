class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  def perform(developer)
    list_id = Rails.application.credentials.mailchimp[:list_id]
    mailchimp_api_key = Rails.application.credentials.mailchimp[:api_key]
    gibbon = Gibbon::Request.new(api_key: mailchimp_api_key)
    gibbon.lists(list_id)
          .members
          .create(body: {
            email_address: developer.email,
            status: "subscribed",
            # merge_fields: {
            #   FNAME: developer.first_name,
            #   LNAME: developer.last_name
            # }
          })
  end

  # def initialize(developer)
  #   @developer = developer
  #   @gibbon = Gibbon::Request.new(api_key: Rails.application.credentials.mailchimp[:api_key])
  #   @list_id = Rails.application.credentials.mailchimp[:list_id]
  # end

  # def call
  #   @gibbon.lists(@list_id).members(Digest::MD5.hexdigest(@developer.email)).upsert(
  #     body: {
  #       email_address: @developer.email,
  #       status: "subscribed",
  #       # merge_fields: {
  #       #   FNAME: @developer.first_name,
  #       #   LNAME: @developer.last_name
  #       # }
  #     }
  #     )
  # end
end
