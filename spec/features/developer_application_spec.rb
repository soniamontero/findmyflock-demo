require 'rails_helper'

feature 'Developer applications' do
  let(:developer) { create :developer, :with_profile, :remote }

  let(:company) { create :company, vetted: true }
  let!(:recruiter) { create :recruiter, company: company }
  let!(:active_job) { create :job, :remote, company: company }
  let!(:another_job) { create :job, :remote, company: company }
  let!(:non_matching_job) { create :job, :office, company: company }

  before do
    sign_in developer
    clear_emails
  end

  scenario 'applies for a job' do
    within('.matched-job', text: active_job.title) do
      click_on 'Details'
    end
    expect(page).to have_content 'Apply to this job'

    fill_in 'Write a message to the recruiter', with: 'A message'
    click_on 'Send application'
    expect(page).to have_content 'Congratulations!'

    click_on 'Dashboard'
    click_on 'Applications'

    within('#nav-profile .matched-job', text: active_job.title) do
      expect(page).to have_content "Current state\nPending"
    end

    within('#nav-home') do
      expect(page).to_not have_content active_job.title
    end
  end

  scenario "can't apply for non-matching job" do
    expect(page).to_not have_content non_matching_job.title

    visit new_job_application_path non_matching_job
    expect(page).to_not have_content 'Apply to this job'
  end

  scenario "can't apply without a resume" do
    developer.resumes.purge
    within('.matched-job', text: active_job.title) { click_on 'Details' }
    click_on 'Send application'

    expect(page).to_not have_content 'Congratulations!'
    expect(emails_sent_to(recruiter.email)).to be_empty
  end

  scenario 'can upload a resume and apply' do
    developer.resumes.purge
    within('.matched-job', text: active_job.title) do
      click_on 'Details'
    end
    expect(page).to have_content 'Apply to this job'

    fill_in 'Write a message to the recruiter', with: 'A message'
    attach_file('application[developer][resumes][]', 'spec/fixtures/asset_test_file.pdf')

    click_on 'Send application'
    expect(developer.reload.resumes.present?).to be true

    expect(page).to have_content 'Congratulations!'
  end

  context 'with a pending application' do
    before do
      within('.matched-job', text: active_job.title) { click_on 'Details' }
      fill_in 'Write a message to the recruiter', with: 'Please hire me'
      click_on 'Send application'
      clear_emails
    end

    scenario 'can see the message they sent' do
      click_on 'Dashboard'
      click_on 'Applications'

      within('#nav-profile .matched-job', text: active_job.title) do
        click_on 'Show'
      end

      expect(page).to have_content 'Please hire me'
    end

    scenario 'job does not show on matched jobs page' do
      click_on 'Dashboard'
      click_on 'Applications'

      within('#nav-home') do
        expect(page).to_not have_content active_job.title
        expect(page).to have_content another_job.title
      end
    end

    scenario 'can withdraw the application' do
      click_on 'Dashboard'
      click_on 'Applications'

      within('#nav-profile .matched-job', text: active_job.title) do
        click_on 'Show'
      end

      click_on 'Withdraw application'

      within('#nav-profile') do
        expect(page).to_not have_content active_job.title
      end
      within('#nav-home') do
        expect(page).to have_content active_job.title
      end
    end

    scenario 'Receives email when application is viewed for the first time' do
      sign_in recruiter
      within('.matched-job', text: developer.full_name) { click_on 'View' }

      open_email developer.email
      expect(current_email).to have_content 'Your application has been opened'
    end

    scenario 'Does not receive email when application is viewed again' do
      sign_in recruiter
      within('.matched-job', text: developer.full_name) { click_on 'View' }
      clear_emails

      click_on 'Dashboard'
      within('.matched-job', text: developer.full_name) { click_on 'View' }

      expect(emails_sent_to(developer.email)).to be_empty
    end
  end
end
