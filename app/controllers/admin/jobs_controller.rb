class Admin::JobsController < Admin::BaseController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /comapies
  # GET /comapies.json
  def index
    @jobs = Job.all.order(created_at: :desc)
  end

  # GET /comapies/1
  # GET /comapies/1.json
  def show
    @matches = Match.where(job_id: params[:id])
  end

  # GET /comapies/new
  def new
    @job = Job.new
  end

  # GET /comapies/1/edit
  def edit
  end

  # POST /comapies
  # POST /comapies.json
  def create
    @job = Job.new(job_params)
    @job.toggle_to_vetted
    respond_to do |format|
      if @job.save
        format.html { redirect_to admin_jobs_path, notice: 'Job was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /comapies/1
  # PATCH/PUT /comapies/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to admin_job_path(@job), notice: 'Job was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /comapies/1
  # DELETE /comapies/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to admin_jobs_url, notice: 'Job was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.all.find(params[:id])
    end

    # (:title, :description, remote:[], benefits:[], cultures:[], :city, :zip_code, :state, :country, :max_salary, :employment_type)

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:title, :active, :description, :city, :zip_code, :state, :country, :max_salary, :employment_type, :can_sponsor, :company_id, :vetted, remote:[], benefits:[], cultures:[])
    end
end
