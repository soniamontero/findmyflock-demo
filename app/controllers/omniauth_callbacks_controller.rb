class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @developer = Identity.find_for_oauth(request.env["omniauth.auth"])

    if @developer.persisted?
      sign_in @developer, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
      @developer.first_login? ? redirect_to(dashboard_developers_path) : redirect_to(edit_profile_developers_path)
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_developer_registration_url, alert: @developer.errors.full_messages.join("\n")
    end
  end

  def linkedin
    @developer = Identity.find_for_oauth(request.env["omniauth.auth"])

    if @developer.persisted?
      sign_in @developer, :event => :authentication
      set_flash_message(:notice, :success, :kind => "LinkedIn") if is_navigational_format?
      @developer.first_login? ? redirect_to(dashboard_developers_path) : redirect_to(edit_profile_developers_path)
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_developer_registration_url, alert: @developer.errors.full_messages.join("\n")
    end
  end
end
