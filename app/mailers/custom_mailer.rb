# frozen_string_literal: true
class CustomMailer < ActionMailer::Base
  include SendGrid

  def admin_jobs_contact(developer_id, custom_text)
    developer = Developer.find(developer_id)
    job_matches = developer.matched_job

    mail = Mail.new
    personalization = Personalization.new
    personalization.add_to(Email.new(email: developer.email))
    personalization.add_dynamic_template_data({
      "custom_text" => custom_text,
      "jobs" => job_matches,
      "name" => developer.full_name
    })
    mail.template_id = 'd-5955a1e9fd2d4821a78079a1f41f3f49' # a non-legacy template id
    mail.add_personalization(personalization)
    mail.from = Email.new(email: 'info@findmyflock.com')

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'] || '')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
