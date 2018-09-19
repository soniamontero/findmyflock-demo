require 'rails_helper'

feature "Matching Jobs" do
  context "with all types of jobs in db" do
    let!(:remote_job) { create :job, :remote, title: 'Remote Job' }
    let!(:remote_job_can_sponsor) { create :job, :remote,
                                    title: 'Remote Can Sponsor Job',
                                    can_sponsor: true }
    let!(:far_away_job) { create :job, :office, title: 'Far Away Job',
                          latitude: 42, longitude: -78 }
    let!(:far_away_job_can_sponsor) { create :job, :office,
                                      title: 'Far Away Can Sponsor Job',
                                      latitude: 42, longitude: -78,
                                      can_sponsor: true }
    let!(:local_job) { create :job, :office, title: 'Local Job', latitude: 40,
                       longitude: -105 }
    let!(:local_job_can_sponsor) { create :job, :office,
                                   title: 'Local Can Sponsor Job', latitude: 40,
                                   longitude: -105, can_sponsor: true }
    let!(:unmatched_skills_job) {
      create :job, :remote_and_office,
      latitude: 40, longitude: -105,
      skills_array: ["ruby/5", "javascript/5"]
    }
    let!(:unmatched_skills_job_can_sponsor) {
      create :job, :remote_and_office,
      latitude: 40, longitude: -105,
      skills_array: ["ruby/5", "javascript/5"],
      can_sponsor: true
    }

    before { sign_in developer }

    context "developer with remote only" do
      let!(:developer) { create :developer, :with_profile, :remote }

      scenario "displays all jobs matching skills" do
        expect(page).to have_content "Matched Jobs"
        expect(page).to have_content remote_job.title
        expect(page).to_not have_content local_job.title
        expect(page).to_not have_content far_away_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end

    context "developer with office only" do
      let!(:developer) { create :developer, :with_profile, :office, latitude: 40, longitude: -105 }

      scenario "displays all jobs matching skills" do
        expect(page).to have_content "Matched Jobs"
        expect(page).to have_content local_job.title
        expect(page).to_not have_content remote_job.title
        expect(page).to_not have_content far_away_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end

    context "developer with remote and office" do
      let!(:developer) { create :developer, :with_profile, :remote_and_office, latitude: 40, longitude: -105 }

      scenario "remote and local jobs display" do
        expect(page).to have_content "Matched Jobs"
        expect(page).to have_content remote_job.title
        expect(page).to have_content local_job.title
        expect(page).to_not have_content far_away_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end

    context "developer with remote and office with full mobility" do
      let!(:developer) { create :developer, :with_profile, :remote_and_office, full_mobility: true }

      scenario "displays all jobs matching skills" do
        expect(page).to have_content "Matched Jobs"
        expect(page).to have_content remote_job.title
        expect(page).to have_content local_job.title
        expect(page).to have_content far_away_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end

    context "developer with office only and full mobility" do
      let!(:developer) { create :developer, :with_profile, :office, full_mobility: true }

      scenario "displays all office jobs matching skills" do
        expect(page).to have_content "Matched Jobs"
        expect(page).to have_content local_job.title
        expect(page).to have_content far_away_job.title
        expect(page).to_not have_content remote_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end

    context "developer with remote and office with full mobility but needs sponsonship" do
      let!(:developer) { create :developer, :with_profile, :remote_and_office, full_mobility: true, need_us_permit: true }

      scenario "displays all jobs matching skills" do
        expect(page).to have_content remote_job_can_sponsor.title
        expect(page).to have_content "Matched Jobs"
        expect(page).to_not have_content remote_job.title
        expect(page).to_not have_content local_job.title
        expect(page).to_not have_content far_away_job.title
        expect(page).to_not have_content unmatched_skills_job.title
      end
    end
  end

  context "with only remote jobs in db" do
    let!(:remote_job) { create :job, :remote }
    let!(:developer) { create :developer, :with_profile, :remote }

    before { sign_in developer }

    scenario "displays remote job" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content remote_job.title
    end
  end

  context "with only local jobs in db" do
    let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
    let!(:developer) { create :developer, :with_profile, :office, latitude: 40, longitude: -105 }

    before { sign_in developer }

    scenario "displays local job" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content local_job.title
    end
  end

  context "with only far away jobs in db" do
    let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:developer) { create :developer, :with_profile, :remote_and_office, full_mobility: true }

    before { sign_in developer }

    scenario "displays job" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to have_content far_away_job.title
    end
  end

  context "with no matching jobs in db" do
    let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:developer) { create :developer, :with_profile, :remote }

    before { sign_in developer }

    scenario "does not display job" do
      expect(page).to have_content "Matched Jobs"
      expect(page).to_not have_content far_away_job.title
    end
  end
end
