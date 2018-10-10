class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    generic_callback('google_oauth2')
  end

  def linkedin
    generic_callback('linkedin')
  end

  def generic_callback(provider_name)
    if provider_name == "google_auth2"
      provider = "Google"
    elsif provider_name == "linkedin"
      provider = "LinkedIn"
    end

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
