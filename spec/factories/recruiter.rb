FactoryBot.define do
  factory :recruiter do
    email { Faker::Internet.email }
    password 'Password1'
    company
  end
end
