FactoryBot.define do
  factory :review_request do
    status { 'active' }

    association :pull_request, strategy: :build
    association :reviewer, factory: :user, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
