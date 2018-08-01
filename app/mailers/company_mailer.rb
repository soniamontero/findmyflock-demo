class CompanyMailer < ApplicationMailer
  default from: 'info@findmyflock.com'

  def welcome_company(company)
    @company = company
    mail(
      from: 'info@findmyflock.com',
      to: company.recruiters.first.email,
      subject: 'New Company Added'
    )
  end

  def new_application_advise(addresses, match, developer)
    @developer = developer
    @job = match.job
    @application = match.application
    mail(
      to: addresses,
      subject: 'New Application Received'
    )
  end

  def contact_developer(message, application, job, developer, address)
    @message = message
    @developer = developer
    @job = job
    @application = application
    mail(
      from: address,
      to: @developer.email,
      subject: 'A Message From Your Recruiter'
    )
  end
end
