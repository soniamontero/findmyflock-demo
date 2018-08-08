Gibbon::Request.api_key = ENV["MAILCHIMP_API_KEY"]
Gibbon::Request.timeout = 15
Gibbon::Request.throws_exceptions = true
puts "MailChimp API key: #{Gibbon::Request.api_key}" # to remove in prod

# api_key = Rails.application.credentials.mailchimp[:api_key]
# list_id = Rails.application.credentials.mailchimp[:list_id]

# Rails.configuration.gibbon = {
#   api_key: api_key,
#   list_id: list_id
# }


