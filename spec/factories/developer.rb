FactoryBot.define do
  factory :developer do
    email { Faker::Internet.email }
    password "Password1"

    trait :with_profile do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      remote ["remote", "office"]
      mobility 25
      full_mobility false
      skills_array ["apache/1", "android/4", "android/3", "android/2", "android/1"]
      sign_in_count 10
      city "123 Main Street, Buffalo, New York, USA"
      zip_code nil
      state "NY"
      country "United States"
      latitude 42.8776271
      longitude -78.876830
    end

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
