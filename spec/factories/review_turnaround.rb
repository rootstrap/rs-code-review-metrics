FactoryBot.define do
  factory :review_turnaround do
    value { Faker::Number.number(digits: 4) }

    association :review_request
    association :pull_request
  end
end
