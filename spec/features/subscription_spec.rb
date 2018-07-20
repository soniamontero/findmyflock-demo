require 'rails_helper'

feature 'Subscriptions' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  
  let(:company) { create :company, :active }
  let(:recruiter) { create :recruiter, company: company }

  before do
    StripeMock.start
    plan = stripe_helper.create_plan id: company.subscriber.plan.stripe_id
    card = stripe_helper.generate_card_token
    customer = Stripe::Customer.create source: card
    @subscription = Stripe::Subscription.create customer: customer.id, items: [{ plan: plan.id }]
    company.subscriber.update stripe_subscription_id: @subscription.id
    
    sign_in recruiter
  end

  after { StripeMock.stop }

  scenario 'recruiter cancels a subscription' do
    visit subscribers_path
    expect(page).to have_content "Manage my subscription"

    click_on "Cancel my subscription"

    stripe_subscription = Stripe::Subscription.retrieve @subscription.id
    expect(stripe_subscription.cancel_at_period_end).to be true

    expect(page).to have_content "Status:\ncanceled"
    expect(page).to have_content "Active Until:\n#{Time.at(stripe_subscription.current_period_end).strftime('%B %e %Y')}"
  end
end
