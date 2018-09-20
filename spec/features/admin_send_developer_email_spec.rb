require 'rails_helper'

feature 'Admin send a developer emails', focus: true do
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

    expect(CustomMailer).to receive(:admin_jobs_contact).with(developer.id).and_call_original
    click_on developer.full_name

    expect(page).to have_content developer.first_name
    expect(page).to have_content job.title
    expect(page).to have_content other_job.title
  end
end
