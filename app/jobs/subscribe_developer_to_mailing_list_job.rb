class SubscribeDeveloperToMailingListJob < ApplicationJob
  queue_as :default

  require 'digest'

  def perform(developer)
    lower_case_md5_hashed_email_address = Digest::MD5.new.update(developer.email.downcase).hexdigest
    list_id = Rails.application.credentials.mailchimp[:list_id]
    mailchimp_api_key = Rails.application.credentials.mailchimp[:api_key]
    gibbon = Gibbon::Request.new(api_key: mailchimp_api_key)

    gibbon.lists(list_id)
      .members(lower_case_md5_hashed_email_address)
      .upsert(
        body: {
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
  #   lower_case_md5_hashed_email_address = Digest::MD5.new.update(@developer.email.downcase).hexdigest
  #   @gibbon.lists(@list_id).members(lower_case_md5_hashed_email_address).upsert(
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

# end

end
