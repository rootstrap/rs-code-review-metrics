FactoryBot.define do
  factory :review_request do
    status { 'active' }
    sequence(:login, 100) { |n| "octocat#{n}" }
    node_id { 'MDQ6VXNlcjE=' }

    association :pull_request, strategy: :build
    association :reviewer, factory: :user, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
