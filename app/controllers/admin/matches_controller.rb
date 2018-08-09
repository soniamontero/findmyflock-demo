class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.all
  end

  def show
    @job_title = Job.find(params[:id]).title
    @matches = Match.where(job_id: params[:id])
  end
end
