class RegistrationsController < Devise::RegistrationsController

  protected

  def after_update_path_for(_resource)
    dashboard_developers_path
  end
end
