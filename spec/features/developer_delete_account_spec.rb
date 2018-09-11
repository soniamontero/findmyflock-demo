require 'rails_helper'

feature 'Deleting developer\'s account' do
  let(:developer)   { create :developer, :with_profile, :remote }
  let(:company) { create :company, vetted: true }

  let!(:recruiter)  { create :recruiter, company: company }
  let!(:active_job) { create :job, :remote, company: company }

  before do
    sign_in developer
    clear_emails

    within('.matched-job', text: active_job.title) { click_on 'Details' }
    fill_in 'Write a message to the recruiter', with: 'Message'
    click_on 'Send application'
    clear_emails
  end
  #   response.should redirect_to '/'
  #   expect(page).to have_content 'FIND THE COMPANY THAT VALUES THE UNIQUE YOU'

  scenario 'recruiter does not receive email if pending status' do
    sign_in recruiter
    click_on 'Applications'
    first('.matched-job', text: active_job.title).click_link('View')
    expect(page).to have_content "Opened"

    click_on "Logout"

    sign_in developer
    visit edit_developer_registration_path
    click_on 'Account Settings'
    click_on 'Delete account'
    Capybara.current_driver = :selenium_chrome
    # accept_alert do
    #   click_link('OK')
    # end

    sign_in recruiter
    expect(emails_sent_to(recruiter.email)).to be_empty
  end

  # scenario 'recruiter receives email if opened status' do
  #   sign_in recruiter
  #   click_on 'Applications'
  #   first('.matched-job', text: active_job.title).click_link('View')
  #   expect(page).to have_content "Current state\nOpened"

  #   sign_in developer
  #   visit edit_developer_registration_path
  #   click_on 'Account Settings'
  #   click on 'Delete account'

  #   page.accept_confirm_alert 'Are you sure?' do
  #     click_link 'Ok'
  #   end

  #   sign_in recruiter
  #   open_email recruiter.email
  #   expect(current_email).to have_content 'We’ve deleted their application and information from your dashboard.'
  # end
end
