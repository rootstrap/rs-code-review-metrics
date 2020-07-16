FactoryBot.define do
  factory :review_turnaround do
    value { Faker::Number.number(digits: 4) }

    association :pull_request
  end
end
