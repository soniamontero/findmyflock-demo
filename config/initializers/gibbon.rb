# Gibbon::API.api_key = ENV["MAILCHIMP_API_KEY"]
# Gibbon::API.timeout = 15
# Gibbon::API.throws_exceptions = true
# puts "MailChimp API key: #{Gibbon::API.api_key}" # to remove in production

Gibbon::API.api_key = Rails.application.credentials[Rails.env.to_sym][:mailchimp][:api_key]
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = true
puts "MailChimp API key: #{Gibbon::API.api_key}" # to remove in production

