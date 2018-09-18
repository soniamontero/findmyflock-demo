# frozen_string_literal: true

class Admin::JobsController < Admin::BaseController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.order(created_at: :desc).includes(:company)
  end

  def show
    @developer_matches = @job.matched_devs
  end

  def new
    @job = Job.new
  end

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

  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to admin_job_path(@job), notice: 'Job was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to admin_jobs_url, notice: 'Job was successfully destroyed.' }
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :title,
      :active,
      :description,
      :city,
      :zip_code,
      :state,
      :country,
      :max_salary,
      :employment_type,
      :can_sponsor,
      :company_id,
      :vetted,
      remote: [],
      benefits: [],
      cultures: []
    )
  end
end
