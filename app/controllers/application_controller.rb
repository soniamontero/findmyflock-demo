class ApplicationController < ActionController::Base

  protected

  def after_sign_in_path_for(resource)
    if resource.class == Developer and disallowed_ip_location
      raise ActionController::RoutingError.new('Not Found')
    end

    if resource.class == Recruiter && resource.company.nil?
      new_company_path
    elsif resource.class == Recruiter
      dashboard_companies_path
    elsif resource.class == Developer && resource.sign_in_count == 1
      edit_profile_developers_path
    elsif resource.class == Developer
      dashboard_developers_path
    elsif resource.class == Admin
      request.env['omniauth.origin'] || stored_location_for(resource) || admin_dashboard_index_path
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
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
    { host: ENV['HOST'] || 'localhost:3000' }
  end
end
