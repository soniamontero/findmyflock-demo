require 'rails_helper'

describe Developer do
  let!(:us_dev) { create :developer, :remote_and_office,
                  need_us_permit: false,
                  skills_array: ["apache/1", "android/3"] }
  let!(:intl_dev) { create :developer, :remote_and_office,
                    need_us_permit: true,
                    skills_array: ["apache/1", "android/3"] }

  context "#active_matched_jobs with sponsoring companies" do
    let!(:local_job) { create :job, :office, latitude: 42, longitude: -78,
                       can_sponsor: true }
    let!(:remote_job) { create :job, :remote, can_sponsor: true }

    it 'shows both jobs for both devs' do
      expect(us_dev.active_matched_jobs).to include local_job
      expect(us_dev.active_matched_jobs).to include remote_job
      expect(intl_dev.active_matched_jobs).to include local_job
      expect(intl_dev.active_matched_jobs).to include remote_job
    end
  end

  context "#active_matched_jobs with no sponsoring companies" do
    let!(:local_job) { create :job, :office, latitude: 42, longitude: -78,
                       can_sponsor: false }
    let!(:remote_job) { create :job, :remote, can_sponsor: false }

    it 'shows both jobs for US dev, neither for intl dev' do
      expect(us_dev.active_matched_jobs).to include local_job
      expect(us_dev.active_matched_jobs).to include remote_job
      expect(intl_dev.active_matched_jobs).not_to include local_job
      expect(intl_dev.active_matched_jobs).not_to include remote_job
    end
  end

  context "#check_for_new_matches" do
    let!(:remote_dev) { create :developer, :remote,
                        skills_array: ["apache/1", "android/3"],
                        notifications: true }
    let!(:off_dev) { create :developer, :remote,
                     skills_array: ["apache/1", "android/3"],
                     notifications: false }

    let!(:local_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:remote_job) { create :job, :remote }
    let!(:other_skills_job) { create :job, :remote, skills_array: ["android/5"] }

    it 'does not return jobs from other devs' do
      expect(remote_dev.notifications?).to be true
      expect(off_dev.notifications?).to be false
      expect(DeveloperMailer).to receive(:new_match_advise).with(us_dev.id, [local_job, remote_job]).and_call_original
      expect(DeveloperMailer).to receive(:new_match_advise).with(remote_dev.id, [remote_job]).and_call_original
      expect(DeveloperMailer).to_not receive(:new_match_advise).with(off_dev.id, [remote_job]).and_call_original
      expect{Developer.check_for_new_matches}.to change{Match.count}.by(4)
    end
  end
end
