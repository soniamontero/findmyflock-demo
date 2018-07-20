FactoryBot.define do
  factory :recruiter do
    email { Faker::Internet.email }
    password 'Password2'
    company
  end
end
