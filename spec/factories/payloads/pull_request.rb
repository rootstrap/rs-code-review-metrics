FactoryBot.define do
  factory :pull_request_payload, class: Hash do
    skip_create
    pull_request do
      {
        id: generate(:pull_request_id),
        number: Faker::Number.number(digits: 1),
        title: "Pull Request-#{Faker::Number.number(digits: 1)}",
        node_id: "#{Faker::Alphanumeric.alphanumeric}=",
        state: 'open',
        locked: 'false',
        draft: 'false',
        user: (attributes_for :user, id: generate(:user_id)).as_json
      }
    end
    requested_reviewer do
      (attributes_for :review_request, id: generate(:review_request_id)).as_json
    end
    initialize_with { attributes.deep_stringify_keys }

    factory :full_pull_request_payload do
      after(:create) do |pull_request_payload|
        pull_request_payload.merge!((create :repository_payload))
      end
    end
  end
end
