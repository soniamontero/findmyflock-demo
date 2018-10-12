class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    authenticate_developer_with('Google')
  end

  def linkedin
    authenticate_developer_with('LinkedIn')
  end

  def authenticate_developer_with(provider)
    @developer = Identity.find_for_oauth(request.env["omniauth.auth"])

    if @developer.persisted?
      sign_in @developer, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}") if is_navigational_format?
      @developer.first_login? ? redirect_to(dashboard_developers_path) : redirect_to(edit_profile_developers_path)
    else
      session["devise.#{provider.downcase}_data"] = request.env["omniauth.auth"]
      redirect_to new_developer_registration_path, alert: @developer.errors.full_messages.join("\n")
    end
  end
end
