api_key = Rails.application.credentials.mailchimp[:api_key]
list_id = Rails.application.credentials.mailchimp[:list_id]

Gibbon::Request.api_key = api_key
Gibbon::Request.timeout = 15
Gibbon::Request.throws_exceptions = true
puts "MailChimp API key: #{Gibbon::Request.api_key}" # to remove in prod
