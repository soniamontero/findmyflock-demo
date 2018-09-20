class Admin::ContactController < Admin::BaseController
  def new
    @developer = Developer.find params[:developer_id]
  end

  def create
    developer_id = params[:developer_id]
    CustomMailer.admin_jobs_contact(developer_id, params[:description]).deliver
    flash_message = 'Your email has been sent. Check Sendgrid for more details.'
    redirect_to admin_developer_path(developer_id), notice: flash_message
  end
end
