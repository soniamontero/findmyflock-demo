module FeatureHelpers
  def sign_in user=nil, password="Password1"
    visit recruiter_session_path
    fill_in 'recruiter_email', with: user.email
    fill_in 'recruiter_password', with: password
    within 'form' do
      click_on 'Log in'
    end
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
