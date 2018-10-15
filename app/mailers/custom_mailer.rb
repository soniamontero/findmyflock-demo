# frozen_string_literal: true
class CustomMailer < ActionMailer::Base
  include SendGrid

  def admin_contact_developer(developer_id, custom_text, custom_text_2)
    developer = Developer.find(developer_id)
    job_matches = developer.active_matched_jobs

    mail = Mail.new
    personalization = Personalization.new
    personalization.add_to(Email.new(email: developer.email))
    # TODO: Delete this next line and the hash value below and instead do this:
    # https://github.com/findmyflock/www/issues/215
    header_image_url = ActionController::Base.helpers
                       .image_url('FMF-Email-Header.png')
    personalization.add_dynamic_template_data({
      "custom_text" => custom_text,
      "custom_text_2" => custom_text_2,
      "jobs" => job_matches,
      "name" => developer.first_name,
      "header_image_url" => header_image_url
    })

    mail.template_id = ENV['SENDGRID_TEMPLATE']
    mail.add_personalization(personalization)
    mail.from = Email.new(email: 'dreamjobs@findmyflock.com')

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'] || '')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    raise StandardError, response.body unless response.body.blank?
  end
end
