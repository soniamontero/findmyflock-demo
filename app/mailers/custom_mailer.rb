# frozen_string_literal: true
class CustomMailer < ActionMailer::Base
  include SendGrid

  def dynamic_template_data_hello_world
    mail = Mail.new
    personalization = Personalization.new
    personalization.add_to(Email.new(email: 'rebecca@example.com'))
    personalization.add_dynamic_template_data({
      "jobs" => "These are the jobs!",
      "name" => 'Rebecca'
    })
    mail.template_id = 'd-5955a1e9fd2d4821a78079a1f41f3f49' # a non-legacy template id
    mail.add_personalization(personalization)
    mail.from = Email.new(email: 'info@findmyflock.com')

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
