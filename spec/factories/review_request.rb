FactoryBot.define do
  sequence(:review_request_id, 100)

  factory :review_request do
    state { 'active' }

    association :pull_request
    association :project
    association :reviewer, factory: :user
    association :owner, factory: :user
  end
end
