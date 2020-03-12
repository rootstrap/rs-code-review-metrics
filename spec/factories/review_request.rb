FactoryBot.define do
  sequence(:review_request_id, 100)

  factory :review_request do
    state { %w[active removed].sample }
    login { "octocat#{Faker::Number.number}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }

    association :pull_request, strategy: :build
    association :reviewer, factory: :user, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
