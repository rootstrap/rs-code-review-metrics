FactoryBot.define do
  factory :review_request do
    status { %w[active removed].sample }
    login { "octocat#{Faker::Number.number}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }

    association :pull_request, strategy: :build
    association :reviewer, factory: :user, strategy: :build
    association :owner, factory: :user, strategy: :build
  end
end
