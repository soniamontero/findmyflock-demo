require 'rails_helper'

feature 'Developer sign up' do
  scenario 'a new developer can sign up' do
    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your developer account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    click_on 'Sign up'

    open_email('mary@exmaple.com')
    current_email.click_link 'CLICK HERE'
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
  end

  scenario 'a new developer must confirm email beefore changing password' do
    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your developer account'
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
