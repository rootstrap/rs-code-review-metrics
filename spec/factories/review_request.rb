FactoryBot.define do
  sequence(:review_request_id, 100)

  factory :review_request do
    state { %w[active removed].sample }

    association :pull_request
    association :reviewer, factory: :user
    association :owner, factory: :user
  end
end
