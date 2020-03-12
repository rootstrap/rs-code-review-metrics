FactoryBot.define do
  factory :review_payload, class: Hash do
    skip_create
    review do
      {
        id: generate(:review_id),
        body: generate(:body),
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        state: generate(:review_state)
      }
    end
    changes do
      {
        body: generate(:body)
      }
    end
    initialize_with { attributes.deep_stringify_keys }

    factory :full_review_payload do
      after(:create) do |review_payload|
        review_payload.merge!((create :pull_request_payload))
        review_payload.merge!((create :repository_payload))
      end
    end
  end
end
