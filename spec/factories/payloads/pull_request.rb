FactoryBot.define do
  factory :pull_request_payload, class: Hash do
    skip_create
    pull_request do
      {
        id: Faker::Number.unique.number(digits: 4),
        number: Faker::Number.number,
        title: "Pull Request-#{Faker::Number.number}",
        node_id: "#{Faker::Alphanumeric.alphanumeric}=",
        state: 'open',
        locked: 'false',
        draft: 'false',
        user: (attributes_for :user, id: Faker::Number.unique.number).as_json
      }
    end
    requested_reviewer { (attributes_for :review_request, id: Faker::Number.unique.number).as_json }
    initialize_with { attributes.deep_stringify_keys }

    factory :pull_request_payload_with_repository do
      after(:create) do |pull_request_payload|
        pull_request_payload.merge!((create :repository_payload))
      end
    end
  end
end
