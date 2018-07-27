FactoryBot.define do
  factory :competence do
    value { Faker::Job.key_skill }
  end
end
