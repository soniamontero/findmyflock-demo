FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    industry { Faker::Company.industry }
    url { Faker::Internet.url }

    trait :active do
      association :subscriber, status: :active
    end

    trait :canceled do
      association :subscriber, status: :canceled, subscription_expires_at: 2.months.ago
    end

    trait :canceled_in_future do
      association :subscriber, status: :canceled, subscription_expires_at: 10.days.from_now
    end
  end
end
