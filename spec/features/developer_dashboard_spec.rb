require 'rails_helper'

feature "Developer dashboard" do
  let!(:developer) { create :developer, :with_profile, :remote }

  let!(:active_company) { create :company, vetted: true }
  let!(:active_job) { create :job, :remote, company_id: active_company.id }

  let!(:inactive_company) { create :company }
  let!(:inactive_job) { create :job, :remote, company_id: inactive_company.id }

  before do
    visit new_developer_session_path
    fill_in 'Email', with: developer.email
    fill_in 'Password', with: developer.password
    click_on 'Log in'
  end

  scenario "does not see jobs for inactive companies" do
    expect(inactive_company.is_active?).to be false
    expect(page).to have_content active_job.title
    expect(page).to_not have_content inactive_job.title
  end
end
