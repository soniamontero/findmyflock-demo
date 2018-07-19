class ApplicationController < ActionController::Base


protected

  def after_sign_in_path_for(resource)
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
end
