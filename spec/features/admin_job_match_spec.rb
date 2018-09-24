require 'rails_helper'

feature 'See Developers that Match Jobs' do
  let!(:admin) { create :admin }

  let!(:remote_job) { create :job, :remote }
  let!(:remote_developer) { create :developer, :with_profile, :remote }

  let!(:ruby_job) { create :job, :remote, skills_array: ["ruby/5", "javascript/5"] }
  let!(:ruby_developer) { create :developer, :with_profile, :remote, skills_array: ["ruby/5", "javascript/5"] }

  before do
    Developer.check_for_new_matches
    sign_in admin
  end

  scenario 'Can see developers that match the job' do
    click_on 'Jobs'
    within 'tr', text: ruby_job.title do
      click_on 'See 1 Match'
    end

    expect(page).to have_content ruby_developer.first_name
    expect(page).to_not have_content remote_developer.first_name
  end

  scenario 'Can see developers on the job show page' do
    click_on 'Jobs'
    click_on ruby_job.title

    expect(page).to have_content ruby_developer.first_name
    expect(page).to_not have_content remote_developer.first_name
  end
end
