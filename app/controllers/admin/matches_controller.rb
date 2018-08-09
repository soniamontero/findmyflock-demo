class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.all
  end

  def show
    @matches = Match.where(job_id: params[:id])
  end

  def refresh_matches
    Developer.check_for_new_matches
    redirect_to admin_matches_path
  end
end
