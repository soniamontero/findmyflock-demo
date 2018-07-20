FactoryBot.define do
  factory :plan do
    stripe_id '3-jobs'
    name '3 Jobs'
    display_price 99.99

    trait :jobs_3 do
      stripe_id '3-jobs'
      name '3 Jobs'
      display_price 99.99
    end

    trait :jobs_1 do
      stripe_id '1-job'
      name '1 Job'
      display_price 39.99
    end
  end
end
