class Admin::DashboardController < Admin::BaseController
  def index
    @developers_count = Developer.count
    @companies_count = Company.count
    @jobs = Job.all
    @applications = Application.all
    @members = Subscriber.all
  end
end
