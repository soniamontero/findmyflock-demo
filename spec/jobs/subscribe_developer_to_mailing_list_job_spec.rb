require 'rails_helper'

describe SubscribeDeveloperToMailingListJob, type: :job do
  let!(:developer) { create :developer }
  let!(:developer_with_name) { create :developer, first_name: 'Sue', last_name: 'Smith' }

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      SubscribeDeveloperToMailingListJob.perform_later(developer)
    }.to have_enqueued_job.with(developer)
  end

  it 'requests mailchimp with the correct arguments' do
    stub = stub_request(:put, /api.mailchimp.com/).
      with(body: "{\"email_address\":\"#{developer.email}\",\"status_if_new\":\"subscribed\",\"merge_fields\":{}}")

    SubscribeDeveloperToMailingListJob.perform_now(developer)
    expect(stub).to have_been_requested
  end

  it 'requests mailchimp with the correct arguments' do
    stub = stub_request(:put, /api.mailchimp.com/).
      with(body: "{\"email_address\":\"#{developer_with_name.email}\",\"status_if_new\":\"subscribed\",\"merge_fields\":{\"FNAME\":\"Sue\",\"LNAME\":\"Smith\"}}")

    SubscribeDeveloperToMailingListJob.perform_now(developer_with_name)
    expect(stub).to have_been_requested
  end
end
