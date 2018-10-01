class Admin::RecruitersController < Admin::BaseController
  before_action :set_recruiter, only: %i[show edit update destroy]

  # GET /recruiters
  # GET /recruiters.json
  def index
    @recruiters = Recruiter.all
  end

  # GET /recruiter/1
  # GET /recruiter/1.json
  def show; end

  # GET /recruiter/new
  def new
    @recruiter = Recruiter.new
  end

  # GET /recruiter/1/edit
  def edit; end

  # POST /recruiter
  # POST /recruiter.json
  def create
    @recruiter = Recruiter.new(recruiter_params)
    @recruiter.skip_confirmation if admin_signed_in?
    respond_to do |format|
      if @recruiter.save
        format.html { redirect_to admin_recruiter_path(@recruiter), notice: 'Recruiter was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /recruiter/1
  # PATCH/PUT /recruiter/1.json
  def update
    respond_to do |format|
      if recruiter_params[:company_id].blank?
        format.html { redirect_to edit_admin_recruiter_path(@recruiter), alert: 'Please select a company.' }
      elsif @recruiter.update(recruiter_params)
        format.html { redirect_to admin_recruiter_path(@recruiter), notice: 'Recruiter was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /recruiter/1
  # DELETE /recruiter/1.json
  def destroy
    @recruiter.destroy
    respond_to do |format|
      format.html { redirect_to admin_recruiters_url, notice: 'Recruiter was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recruiter
    @recruiter = Recruiter.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.

  def recruiter_params
    params.require(:recruiter).permit(:email, :password, :password_confirmation, :company_id)
  end
end
