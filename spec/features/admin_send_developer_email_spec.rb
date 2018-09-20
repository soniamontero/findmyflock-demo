require 'rails_helper'

feature 'Admin send a developer emails' do
  let!(:admin) { create :admin }

  let!(:job) { create :job, :remote, skills_array: ["ruby/4"] }
  let!(:other_job) { create :job, :remote, skills_array: ["ruby/4", "javascript/4"] }
  let!(:developer) { create :developer, :with_profile, :remote, skills_array: ["ruby/4", "javascript/4"] }

  before do
    Developer.check_for_new_matches
    sign_in admin
  end

  scenario 'Can send a custom email' do
    click_on 'Developers'
    click_on developer.full_name

    custom_text = 'Hello! We think you would be a great match for these jobs.'
    expect(CustomMailer).to receive(:admin_contact_developer).with(developer.id.to_s, custom_text).and_call_original

    click_on 'Email this user'
    fill_in :description, with: custom_text
    click_on 'Send Email'
    expect(page).to have_content 'Your email has been sent'
  end
end
