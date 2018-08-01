require "rails_helper"

HEADERS = { "CONTENT_TYPE" => "application/json" }

describe "Stripe Webhooks" do
  before { StripeMock.start }
  after { StripeMock.stop }

  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:stripe_plan) { stripe_helper.create_plan id: 'fkx0AFo_00000000000000' }
  let!(:plan) { create :plan, stripe_id: stripe_plan.id }

  let(:stripe_customer) { Stripe::Customer.create source: stripe_helper.generate_card_token }
  let(:stripe_subscription) do
    Stripe::Subscription.create customer: stripe_customer.id, items: [{ plan: plan.stripe_id }]
  end
  let!(:subscriber) do
    create :subscriber,
      status: :trialing,
      stripe_customer_id: stripe_customer.id,
      stripe_subscription_id: stripe_subscription.id
  end

  it "updates a subscription when created on stripe" do
    event = StripeMock.mock_webhook_event('customer.subscription.created', {
      customer: stripe_customer.id
    })
    post "/stripe/webhooks", params: event.to_json, headers: HEADERS
    expect(response.body).to eq 'success'

    expect(subscriber.reload.status).to eq 'active'
    event_start_time = Time.at(event.data.object.current_period_start).to_datetime
    expect(subscriber.subscribed_at).to eq event_start_time
    event_end_time = Time.at(event.data.object.current_period_end).to_datetime
    expect(subscriber.subscription_expires_at).to eq event_end_time
  end

  it "updates a subscription when updated on stripe" do
    event = StripeMock.mock_webhook_event('customer.subscription.updated', {
      customer: stripe_customer.id
    })
    post "/stripe/webhooks", params: event.to_json, headers: HEADERS
    expect(response.body).to eq 'success'

    expect(subscriber.reload.status).to eq 'active'
    event_end_time = Time.at(event.data.object.current_period_end).to_datetime
    expect(subscriber.subscription_expires_at).to eq event_end_time
    expect(subscriber.plan).to eq plan
  end

  it "cancels a subscription when canceled on stripe" do
    event = StripeMock.mock_webhook_event('customer.subscription.deleted', {
      customer: stripe_customer.id
    })
    post "/stripe/webhooks", params: event.to_json, headers: HEADERS
    expect(response.body).to eq 'success'

    expect(subscriber.reload.status).to eq 'canceled'
    event_end_time = Time.at(event.data.object.current_period_end).to_datetime
    expect(subscriber.subscription_expires_at).to eq event_end_time
  end

  it "updates a subscription when a payment succeeds" do
    event = StripeMock.mock_webhook_event('invoice.payment_succeeded', {
      customer: stripe_customer.id
    })
    post "/stripe/webhooks", params: event.to_json, headers: HEADERS
    expect(response.body).to eq 'success'

    expect(subscriber.reload.status).to eq 'active'
    event_end_time = Time.at(stripe_subscription.current_period_end).to_datetime
    expect(subscriber.subscription_expires_at).to eq event_end_time
  end
end
