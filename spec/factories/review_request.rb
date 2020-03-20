FactoryBot.define do
  sequence(:review_request_id, 100)

  factory :review_request do
    state { %w[active removed].sample }
    login { "octocat#{Faker::Number.number}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }

    association :pull_request
    association :reviewer, factory: :user
    association :owner, factory: :user
  end
end
