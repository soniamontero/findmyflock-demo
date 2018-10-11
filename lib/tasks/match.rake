namespace :match do
  desc "TODO"
  task notification: :environment do
    Developer.check_for_new_matches
  end

end
