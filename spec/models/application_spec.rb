require 'rails_helper'

describe Application do
  let(:developer) { create :developer, :with_profile, :remote }
  let(:company) { create :company, vetted: true }
  let!(:recruiter) { create :recruiter, company: company }
  let(:job) { create :job, company: company }
  let(:match) { create :match, job: job, developer: developer}

  context 'last mail is more than 7 days' do
    context 'status is pending or opened' do
      let(:pending_application) {
                                  create :application,
                                  match: match,
                                  status: 'pending',
                                  last_mail_sent: 10.days.ago
                                }
      let(:opened_application) {
                                 create :application,
                                 match: match,
                                 status: 'opened',
                                 last_mail_sent: 10.days.ago
                               }

      it 'sends a reminder to the recruiter' do
        expect(CompanyMailer).to receive(:application_reminder)
                             .with([pending_application.id, opened_application.id])
                             .and_call_original
        expect(Application.reminder).to include company
        Application.reminder
      end
    end

    context 'status is contacted or rejected' do
      let(:contacted_application) {
                                    create :application,
                                    match: match,
                                    status: 'contacted',
                                    last_mail_sent: 10.days.ago
                                  }
      let(:rejected_application) {
                                   create :application,
                                   match: match,
                                   status: 'rejected',
                                   last_mail_sent: 10.days.ago
                                 }

      it 'does not send a reminder to the recruiter' do
        expect(CompanyMailer).to_not receive(:application_reminder)
                             .with([contacted_application.id, rejected_application.id])
                             .and_call_original
        expect(Application.reminder).to include company
        Application.reminder
      end
    end
  end

  context 'last mail is less than 7 days' do
    context 'application is contacted or rejected' do
      let(:contacted_application) {
                                    create :application,
                                    match: match,
                                    status: 'contacted',
                                    last_mail_sent: 2.days.ago
                                  }
      let(:rejected_application) {
                                   create :application,
                                   match: match,
                                   status: 'rejected',
                                   last_mail_sent: 2.days.ago
                                 }

      it 'does not send a reminder to the recruiter' do
        expect(CompanyMailer).to_not receive(:application_reminder)
                             .with([contacted_application.id, rejected_application.id])
                             .and_call_original
        expect(Application.reminder).to include company
        Application.reminder
      end
    end

    context 'application is pending or opened' do
      let(:pending_application) { create :application,
                                  match: match,
                                  status: 'pending',
                                  last_mail_sent: 2.days.ago
                                }
      let(:opened_application) {
                                 create :application,
                                 match: match,
                                 status: 'pending',
                                 last_mail_sent: 2.days.ago
                               }

      it 'does not send a reminder to the recruiter' do
        expect(CompanyMailer).to_not receive(:application_reminder)
                             .with([pending_application.id, opened_application.id])
                             .and_call_original
        expect(Application.reminder).to include company
        Application.reminder
      end
    end
  end
end
