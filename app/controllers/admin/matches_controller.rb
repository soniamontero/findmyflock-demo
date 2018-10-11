class Admin::MatchesController < Admin::BaseController
  def index
    @matches = Match.includes(:application, :developer, job: :company)
  end

  def show
    @job = Job.find(params[:id])
    @job_title = @job.title
    @job_company = @job.company
    @job_location = "#{@job.city}, #{@job.state}, #{@job.country}"
    @job_mobility = @job.remote
    matches_array = Match.where(job_id: params[:id]).includes(:developer)
    @matches = matches_array.sort_by{|match| [ match.developer.distance_from(@job) ]}
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
