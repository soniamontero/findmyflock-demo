FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password "Password1"
  end
end
