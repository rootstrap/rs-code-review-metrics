FactoryBot.define do
  factory :review_request do
    status { 'active' }
    node_id { 'MDExOlB1bGxc5MTQ3NDM3' }
    login { 'octocat' }

    association :pull_request, strategy: :build
    association :reviewer, factory: :user, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
