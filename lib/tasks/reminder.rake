namespace :application do
  desc "Check if need to send an application reminder to recruiter"
  task reminder: :environment do
    t = Time.now
    if t.saturday?
      ## RUNNING ONLY IN WEEKENDS
    end
    Application.reminder
  end
end
