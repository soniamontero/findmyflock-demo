class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.all
  end

  def show
    @matches = Match.where(job_id: params[:id])
  end
end
