class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?

  protected

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for resource_or_scope
    # if resource.class == Developer and disallowed_ip_location
    #   raise ActionController::RoutingError.new('Not Found')
    # end

    request.env['omniauth.origin'] ||
      stored_location_for(resource_or_scope) ||
      signed_in_root_path(resource_or_scope) ||
      root_path
  end

  def disallowed_ip_location
    return false unless Rails.env.production?
    country = session[:country] || (session[:country] = lookup_country)
    country.present? and not country.in? allowed_countries
  end

  def lookup_country
    ip = request.remote_ip
    response = Net::HTTP.get_response URI.parse "http://ipinfo.io/#{ip}/country"
    if response.code == '200'
      response.body.strip rescue ''
    end
  end

  def allowed_countries
    ENV['ALLOWED_COUNTRIES'].split(',') rescue ['US', 'ID']
  end

  def default_url_options
    { host: ENV['DOMAIN'] || 'localhost:3000' }
  end
end
