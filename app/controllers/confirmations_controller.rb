class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    if resource_name == :developer
      edit_profile_developers_path
    else
      super
    end
  end
end
