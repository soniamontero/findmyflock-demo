require 'rails_helper'

describe Company do
  context '#active' do
    subject { Company.active }

    let!(:vetted) { create :company, vetted: true }
    let!(:active) { create :company, :active }
    let!(:canceled_in_future) { create :company, :canceled_in_future }
    let!(:canceled_in_past) { create :company, :canceled }

    it 'shows vetted companies' do
      expect(subject).to include vetted
    end

    it 'shows active companies' do
      expect(subject).to include active
    end

    it 'shows canceled companies that have not passed their cancelation dates' do
      expect(subject).to include canceled_in_future
    end

    it 'does not show canceled companies that have passed their cancelation dates' do
      expect(subject).to_not include canceled_in_past
    end
  end
end
