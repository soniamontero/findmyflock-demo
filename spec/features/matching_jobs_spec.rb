require 'rails_helper'

feature "Matching Jobs" do
  let!(:remote_job) { create :job, :remote }
  let!(:remote_job_can_sponsor) { create :job, :remote, can_sponsor: true }
  let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
  let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
  let!(:unmatched_skills_job) {
    create :job, :remote_and_office,
    latitude: 40, longitude: -105,
    skills_array: ["ruby/5", "javascript/5"]
  }

  before do
    visit new_developer_session_path
    fill_in 'Email', with: developer.email
    fill_in 'Password', with: developer.password
    click_on 'Log in'
  end

  context "with remote only" do
    let!(:developer) { create :developer, :with_profile, :remote }

    scenario "displays all jobs matching skills" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content remote_job.title
      expect(page).to_not have_content local_job.title
      expect(page).to_not have_content far_away_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end

  context "with office only" do
    let!(:developer) { create :developer, :with_profile, :office, latitude: 40, longitude: -105 }

    scenario "displays all jobs matching skills" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content local_job.title
      expect(page).to_not have_content remote_job.title
      expect(page).to_not have_content far_away_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end

  context "with remote and office" do
    let!(:developer) { create :developer, :with_profile, :remote_and_office, latitude: 40, longitude: -105 }

    scenario "remote and local jobs display" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content remote_job.title
      expect(page).to have_content local_job.title
      expect(page).to_not have_content far_away_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end

  context "with remote and office with full mobility" do
    let!(:developer) { create :developer, :with_profile, :remote_and_office, full_mobility: true }

    scenario "displays all jobs matching skills" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content remote_job.title
      expect(page).to have_content local_job.title
      expect(page).to have_content far_away_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end

  context "with office only and full mobility" do
    let!(:developer) { create :developer, :with_profile, :office, full_mobility: true }

    scenario "displays all office jobs matching skills" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content local_job.title
      expect(page).to have_content far_away_job.title
      expect(page).to_not have_content remote_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end

  context "with remote and office with full mobility but needs sponsonship" do
    let!(:developer) { create :developer, :with_profile, :remote_and_office, full_mobility: true, need_us_permit: true }

    scenario "displays all jobs matching skills" do
      expect(page).to have_content remote_job_can_sponsor.title
      expect(page).to have_content "Matched Jobs"
      expect(page).to_not have_content remote_job.title
      expect(page).to_not have_content local_job.title
      expect(page).to_not have_content far_away_job.title
      expect(page).to_not have_content unmatched_skills_job.title
    end
  end
end
