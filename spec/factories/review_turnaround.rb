FactoryBot.define do
  factory :review_turnaround do
    value { Faker::Number.number(digits: 4) }

    association :review_request
  end
end
