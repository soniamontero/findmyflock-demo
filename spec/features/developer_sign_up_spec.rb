require 'rails_helper'

feature 'Developer sign up' do
  scenario 'a new developer can sign up' do
    visit root_path
    click_on 'Join'
    expect(page).to have_content 'Create your account'
    fill_in 'Email', with: 'mary@exmaple.com'
    fill_in 'Password', with: 'Password1'
    fill_in 'Password confirmation', with: 'Password1'
    click_on 'Sign up'

    open_email('mary@exmaple.com')
    current_email.click_link 'CLICK HERE'
  end
end
