class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for resource_or_scope
    request.env['omniauth.origin'] ||
      stored_location_for(resource_or_scope) ||
      signed_in_root_path(resource_or_scope) ||
      root_path
  end

  def default_url_options
    { host: ENV['DOMAIN'] || 'localhost:3000' }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:subscribed_to_newsletter])
  end
end
