require 'rails_helper'

describe Job do
  context '#local_office' do
    let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
    let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:local_remote_job) { create :job, :remote_and_office, latitude: 40, longitude: -105 }
    let!(:remote_job) { create :job, :remote, latitude: 40, longitude: -105 }

    it 'shows jobs near location' do
      expect(Job.local_office(100, 40.1, -105.1)).to include local_job
      expect(Job.local_office(100, 40.1, -105.1)).to include local_remote_job
    end

    it 'does not show remote only' do
      expect(Job.local_office(100, 40.1, -105.1)).to_not include remote_job
    end

    it 'does not show office jobs outside provided location' do
      expect(Job.local_office(100, 40.1, -105.1)).to_not include far_away_job
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

  context '#local_and_remote', focus: true do
    let!(:local_job) { create :job, :office, latitude: 40, longitude: -105 }
    let!(:far_away_job) { create :job, :office, latitude: 42, longitude: -78 }
    let!(:local_remote_job) { create :job, :remote_and_office, latitude: 40, longitude: -105 }
    let!(:remote_job) { create :job, :remote, latitude: 40, longitude: -105 }

    it 'shows jobs near location' do
      expect(Job.local_and_remote(100, 40.1, -105.1)).to include local_job
      expect(Job.local_and_remote(100, 40.1, -105.1)).to include local_remote_job
    end

    it 'shows remote' do
      expect(Job.local_and_remote(100, 40.1, -105.1)).to include remote_job
    end

    it 'does not show office jobs outside provided location' do
      expect(Job.local_and_remote(100, 40.1, -105.1)).to_not include far_away_job
    end
  end
end
