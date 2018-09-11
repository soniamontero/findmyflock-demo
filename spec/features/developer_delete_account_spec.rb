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

  scenario 'recruiter does not receive email if application not opened' do
    sign_in recruiter
    click_on 'Applications'
    within first('.matched-job', text: active_job.title) do
      expect(page).to have_content "New"
    end

    click_on "Logout"

    sign_in developer
    visit edit_developer_registration_path
    click_on 'Account Settings'
    click_on 'Delete account'
    expect(page).to have_content 'Find the company that values the unique you'

    sign_in recruiter
    expect(emails_sent_to(recruiter.email)).to be_empty
    end

  scenario 'recruiter receives email if opened status' do
    sign_in recruiter
    click_on 'Applications'
    first('.matched-job', text: active_job.title).click_link('View')
    expect(page).to have_content "Opened"

    click_on "Logout"

    sign_in developer
    visit edit_developer_registration_path
    click_on 'Account Settings'
    click_on 'Delete account'
    expect(page).to have_content 'Find the company that values the unique you'

    sign_in recruiter
    open_email recruiter.email
    expect(current_email).to have_content 'We’ve deleted their application and information from your dashboard.'
  end
end
