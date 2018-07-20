FactoryBot.define do
  factory :subscriber do
    company
    association :plan, :jobs_3
    status :active
    stripe_customer_id 'fake_stripe_customer_id'
    stripe_subscription_id 'fake_stripe_subscription_id'
  end
end
