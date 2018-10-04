class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/developer.rb)
    @developer = Developer.from_omniauth(request.env['omniauth.auth'])

#     if @developer.persisted?
#       flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
#       sign_in_and_redirect @developer, event: :authentication
#     else
#       session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
#       redirect_to new_developer_registration_url, alert: @developer.errors.full_messages.join("\n")
#     end
#   end
# end

    if @developer.persisted?
      sign_in @developer, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
      @developer.first_login? ? redirect_to(dashboard_developers_path) : redirect_to(edit_profile_developers_path)
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_developer_registration_url, alert: @developer.errors.full_messages.join("\n")
    end
  end
end
