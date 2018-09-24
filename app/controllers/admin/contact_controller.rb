class Admin::ContactController < Admin::BaseController
  def new
    @developer = Developer.find params[:developer_id]
  end

  def create
    developer_id = params[:developer_id]
    custom_text = params[:custom_text]
    custom_text_2 = params[:custom_text_2]
    CustomMailer.admin_contact_developer(developer_id, custom_text, custom_text_2).deliver
    flash_message = 'Your email has been sent. Check Sendgrid for more details.'
    redirect_to admin_developer_path(developer_id), notice: flash_message
  end
end
