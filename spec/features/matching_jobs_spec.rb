require 'rails_helper'

feature "Matching Jobs" do
  context "with remote and office selected in profile" do
    let!(:remote_job) { create :job, :remote }
    let!(:developer) { create :developer, :with_profile, :remote_and_office }

    before do
      visit new_developer_session_path
      fill_in 'Email', with: developer.email
      fill_in 'Password', with: developer.password
      click_on 'Log in'
    end

    scenario "remote jobs display", focus: true do
      expect(page).to have_content "Matched Jobs"
      # save_and_open_page
      expect(page).not_to have_content "No jobs match"
      expect(page).to have_content remote_job.title
    end
  end
end
