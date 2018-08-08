api_key = Rails.application.credentials.mailchimp[:api_key]
list_id = Rails.application.credentials.mailchimp[:list_id]

Rails.configuration.gibbon = {
  api_key: api_key,
  list_id: list_id
}

gibbon = Gibbon::Request.new(api_key: api_key)
gibbon.timeout = 15
gibbon.throws_exceptions = true
puts "MailChimp API key: #{gibbon}" # to remove in prod


