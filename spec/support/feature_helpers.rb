module FeatureHelpers
  def sign_in user=nil, password="Password1"
    if user.is_a? Developer
      visit new_developer_session_path unless current_path == new_developer_session_path
    elsif user.is_a? Admin
      visit admin_session_path
    else
      visit recruiter_session_path unless current_path == recruiter_session_path
    end

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    within 'form' do
      click_on 'Log in'
    end
  end
end

def mock_auth_hash
  # The mock_auth configuration allows you to set per-provider (or default)
  # authentication hashes to return during integration testing.
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    'provider' => 'google_oauth2',
    'uid' => '123545',
    'info' => {
      'first_name' => 'mockuser',
      'last_name' => 'useruser'
    },
    'credentials' => {
      'token' => 'mock_token',
      'secret' => 'mock_secret'
    }
  })
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end


