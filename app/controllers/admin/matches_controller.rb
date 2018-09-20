class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.includes(:application, :developer, job: :company)
  end

  def show
    @job_title = Job.find(params[:id]).title
    @matches = Match.where(job_id: params[:id]).includes(:developer)
  end

  def update
    match = Match.find(params[:id])

    respond_to do |format|
      if match.update(match_params)
        format.html { redirect_to request.referrer, notice: 'Match was successfully updated.' }
      else
        match.destroy unless match.valid?
        format.html { redirect_to request.referrer, alert: match.errors.full_messages.to_sentence }
      end
    end
  end

  def match_params
    params.require(:match).permit(:status)
  end
end
