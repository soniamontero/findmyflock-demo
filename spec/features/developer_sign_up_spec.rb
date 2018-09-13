require 'rails_helper'

feature 'Developer sign up' do
  let(:developer_country) { 'US' }
  before do
    stub_request(:get, /ipinfo.io/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: developer_country, headers: {})
  end

  scenario 'a new developer can sign up' do
    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your job seeker account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    click_on 'Sign up'

    open_email('mary@exmaple.com')
    current_email.click_link 'CLICK HERE'
  end

  scenario 'a new developer can sign up and join the mailing list' do
    ActiveJob::Base.queue_adapter = :test

    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your job seeker account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    expect {
      click_on 'Sign up'
    }.to have_enqueued_job(SubscribeDeveloperToMailingListJob)

    expect(emails_sent_to('mary@exmaple.com').count).to eq 1
  end

  scenario 'a new developer can sign up and opt out of the mailing list' do
    ActiveJob::Base.queue_adapter = :test

    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your job seeker account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    uncheck 'developer[gets_mail]'
    expect {
      click_on 'Sign up'
    }.to_not have_enqueued_job(SubscribeDeveloperToMailingListJob)

    expect(emails_sent_to('mary@exmaple.com').count).to eq 1
  end

  context 'creates a profile' do
    let!(:new_developer) { create :developer}
    let!(:developer) { create :developer, sign_in_count: 2 }
    let!(:rails_competence) { create :competence, value: "Rails" }
    let!(:competencies) { create_list :competence, 5 }

    scenario 'cannot continue without office or remote checked' do
      sign_in new_developer
      expect(page).to have_content "We're glad you're here!"
      fill_in 'First name', with: 'Susie'
      fill_in 'Last name', with: 'Jones'

      click_on 'Continue'
      expect(page).to have_content "We're glad you're here!"
    end

    scenario 'cannot continue without skills' do
      sign_in new_developer
      expect(page).to have_content "We're glad you're here!"
      fill_in 'First name', with: 'Susie'
      fill_in 'Last name', with: 'Jones'
      check 'developer_remote_remote'
      click_on 'Continue'
      expect(current_path).to eq add_skills_developers_path

      click_on "Continue to your dashboard"
      expect(page).to_not have_content "Matched Jobs"
      expect(current_path).to eq add_skills_developers_path
      expect(page).to have_content "Please complete your profile"
    end

    scenario 'with all required info redirects to dashboard', js: true do
      sign_in developer
      expect(current_path).to eq edit_profile_developers_path
      fill_in 'First name', with: 'Susie'
      fill_in 'Last name', with: 'Jones'
      find('[for=developer_remote_remote]', visible: false).click
      click_on 'Continue'
      expect(current_path).to eq add_skills_developers_path

      fill_in 'Select a skill...', with: "Rails"
      find('.dropdown-item', match: :first).click
      # unable to select different levels within the test
      click_on "Add to your skills"

      fill_in 'Select a skill...', with: competencies.first.value
      find('.dropdown-item', match: :first).click
      click_on "Add to your skills"

      click_on "Continue to your dashboard"
      expect(page).to have_content(/Matched Jobs/i)
      expect(developer.reload.skills_array).to match_array ["Rails/1", "#{competencies.first.value}/1"]
    end

    scenario 'uploads a resume' do
      sign_in developer
      expect(current_path).to eq edit_profile_developers_path
      fill_in 'First name', with: 'Susie'
      fill_in 'Last name', with: 'Jones'
      attach_file('developer[resumes][]', 'spec/fixtures/asset_test_file.pdf')
      find('[for=developer_remote_remote]', visible: false).click
      click_on 'Continue'

      expect(developer.reload.resumes.present?).to be true
    end

    scenario 'US developer does not see tips' do
      sign_in developer
      visit add_skills_developers_path
      expect(page).to_not have_content 'Important Tips'
    end

    context 'a non-US developer' do
      let(:developer_country) { 'ID' }

      scenario 'sees tips' do
        sign_in developer
        visit add_skills_developers_path
        expect(page).to have_content 'Important Tips'
      end
    end
  end

  scenario 'a new developer must confirm email beefore changing password' do
    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your job seeker account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    click_on 'Sign up'

    click_on 'Logout'
    click_on 'Login'
    click_on 'Forgot your password?'
    fill_in 'Email', with: 'mary@exmaple.com'
    click_on 'Send me'

    open_email('mary@exmaple.com')
    current_email.click_link 'Change my password'

    expect(page).to have_content "Change your password"
    fill_in 'New password', with: 'Password2'
    fill_in 'Confirm your new password', with: 'Password2'
    expect(page).to have_content "Change your password"
    expect(page).to have_content "confirm your email"
  end
end
