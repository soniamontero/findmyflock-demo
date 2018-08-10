require 'rails_helper'

describe Job do
  context '#check_location' do
    let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
    let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:local_remote_job) { create :job, :remote_and_office, latitude: 40, longitude: -105 }

    it 'shows jobs near location' do
      expect(Job.check_location(100, 40.1, -105.1)).to include local_job
      expect(Job.check_location(100, 40.1, -105.1)).to include local_remote_job
    end

    it 'does not show office jobs outside provided location' do
      expect(Job.check_location(100, 40.1, -105.1)).to_not include far_away_job
    end
  end

  context '#all_remotes' do
    let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
    let!(:remote_job) { create :job, :remote, latitude: 40, longitude: -105 }
    let!(:local_remote_job) { create :job, :remote_and_office, latitude: 40, longitude: -105 }

    it 'shows both remote jobs' do
      expect(Job.all_remote).to include remote_job
      expect(Job.all_remote).to include local_remote_job
    end

    it 'does not show office-only job' do
      expect(Job.all_remote).to_not include local_job
    end
  end

  context '#matched_devs', focus: true do
    let!(:unmatched_skills_dev) {
      create :developer, :with_profile, :remote_and_office,
      latitude: 40, longitude: -105,
      skills_array: ["ruby/5", "javascript/5"]
    }
    let!(:remote_dev) { create :developer, :with_profile, :remote }
    let!(:local_dev) { create :developer, :with_profile, :office, latitude: 40, longitude: -105 }
    let!(:far_away_dev) { create :developer, :with_profile, :office, latitude: 42, longitude: -78 }
    let!(:remote_and_office_dev) { create :developer, :with_profile, :remote_and_office, latitude: 40, longitude: -105 }
    let!(:full_mobility_office_dev) { create :developer, :with_profile, :office, full_mobility: true }
    let!(:full_mobility_and_remote_dev) { create :developer, :with_profile, :remote_and_office, full_mobility: true }

    context 'remote job' do
      let!(:remote_job) { create :job, :remote }

      scenario 'only matches remote devs' do
        expect(remote_job.matched_devs).to include remote_dev
        expect(remote_job.matched_devs).to include full_mobility_and_remote_dev
        expect(remote_job.matched_devs).to include remote_and_office_dev
        expect(remote_job.matched_devs).to_not include local_dev
        expect(remote_job.matched_devs).to_not include unmatched_skills_dev
      end
    end

    context 'office job' do
      let!(:office_job) { create :job, :office, latitude: 40, longitude: -105 }

      scenario 'matches local devs' do
        expect(office_job.matched_devs).to include local_dev
        expect(office_job.matched_devs).to_not include far_away_dev
        expect(office_job.matched_devs).to_not include unmatched_skills_dev
      end

      scenario 'matches full_mobility (all office) devs' do
        expect(office_job.matched_devs).to include full_mobility_office_dev
        expect(office_job.matched_devs).to include remote_and_office_dev
        expect(office_job.matched_devs).to include full_mobility_and_remote_dev
      end

      scenario 'does not matches remote only devs' do
        expect(office_job.matched_devs).to_not include remote_dev
      end
    end

    context 'remote or office job' do
      let!(:office_job) { create :job, :remote_and_office, latitude: 40, longitude: -105 }

      scenario 'matches local devs' do
        expect(office_job.matched_devs).to include local_dev
        expect(office_job.matched_devs).to_not include far_away_dev
        expect(office_job.matched_devs).to_not include unmatched_skills_dev
      end

      scenario 'matches full_mobility (all office) devs' do
        expect(office_job.matched_devs).to include remote_and_office_dev
        expect(office_job.matched_devs).to include full_mobility_office_dev
        expect(office_job.matched_devs).to include full_mobility_and_remote_dev
      end

      scenario 'matches remote devs' do
        expect(office_job.matched_devs).to include remote_dev
      end
    end

    context 'sponsoring jobs' do
      let!(:us_dev) { create :developer, :remote_and_office,
        need_us_permit: false,
        skills_array: ["apache/1", "android/3"] }
      let!(:intl_dev) { create :developer, :remote_and_office,
        need_us_permit: true,
        skills_array: ["apache/1", "android/3"] }

      context 'with sponsoring companies' do
        let!(:local_job) { create :job, :office, latitude: 42, longitude: -78,
          can_sponsor: true }
        let!(:remote_job) { create :job, :remote, can_sponsor: true }

        it 'shows both devs for both jobs' do
          expect(local_job.matched_devs).to include us_dev
          expect(local_job.matched_devs).to include intl_dev
          expect(remote_job.matched_devs).to include us_dev
          expect(remote_job.matched_devs).to include intl_dev
        end
      end

      context '#matched_devs with no sponsoring companies' do
        let!(:local_job) { create :job, :office, latitude: 42, longitude: -78,
                           can_sponsor: false }
        let!(:remote_job) { create :job, :remote, can_sponsor: false }

        it 'shows both jobs for US dev, neither for intl dev' do
          expect(local_job.matched_devs).to include us_dev
          expect(local_job.matched_devs).to_not include intl_dev
          expect(remote_job.matched_devs).to include us_dev
          expect(remote_job.matched_devs).not_to include intl_dev
        end
      end
    end
  end
end
