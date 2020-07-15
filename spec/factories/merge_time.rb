FactoryBot.define do
  factory :merge_time do
    value { Faker::Number.number(digits: 4) }

    association :pull_request
  end
end
