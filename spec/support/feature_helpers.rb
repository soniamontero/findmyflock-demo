module FeatureHelpers
  def sign_in user=nil, password="Password1"
    if user.is_a? Developer
      visit new_developer_session_path
    else
      visit recruiter_session_path
    end

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    within 'form' do
      click_on 'Log in'
    end
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
