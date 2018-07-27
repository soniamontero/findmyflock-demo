require 'rails_helper'

describe Developer do
  context "#matched_job" do
    let!(:local_job) { create :job, :office, latitude: 42, longitude: -78,
                       can_sponsor: true }
    let!(:remote_job) { create :job, :remote, can_sponsor: true }
    let!(:us_dev) { create :developer, :remote_and_office,
                    need_us_permit: false,
                    skills_array: ["apache/1", "android/3"] }
    let!(:intl_dev) { create :developer, :remote_and_office,
                      need_us_permit: true,
                      skills_array: ["apache/1", "android/3"] }

    it 'shows both jobs for both devs' do
      expect(us_dev.matched_job).to include local_job
      expect(us_dev.matched_job).to include remote_job
      expect(intl_dev.matched_job).to include local_job
      expect(intl_dev.matched_job).to include remote_job
    end
  end
end
