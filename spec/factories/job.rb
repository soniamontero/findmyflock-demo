FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    description "<p>THere are some things you can do</p>"
    city "Loveland"
    zip_code nil
    state "CO"
    country "United States"
    active true
    remote ["remote"]
    latitude 40.3977612
    longitude -105.0749801
    max_salary 50000
    skills_array ["apache/1", "android/3"]
    employment_type "Part-Time"
    benefits [ "Office Dogs",
      "Equity",
      "30+ Days Parental Leave",
      "Environmental Mission",
      "80%+ Covered Health Insurance",
      "Professional Development Budget",
      "Lunch Provided",
      "Mountain Within 60 Minutes"]
    cultures ["Cubicles", "No cubicles", "ping pong", "Game Nights"]
    can_sponsor false
    association :company, :active

    trait :remote do
      remote ["remote"]
    end

    trait :office do
      remote ["office"]
    end

    trait :remote_and_office do
      remote ["remote", "office"]
    end
  end
end
