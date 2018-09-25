namespace :application do
  desc "Check if need to send an application reminder to recruiter"
  task reminder: :environment do
    t = Time.now
    Application.reminder
  end
end
