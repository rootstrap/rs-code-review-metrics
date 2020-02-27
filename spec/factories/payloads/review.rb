FactoryBot.define do
  factory :review_payload, class: Hash do
    skip_create

    transient do
      submitted_at { Faker::Date.between(from: 1.month.ago, to: Date.yesterday) }
    end

    action { %w[submitted edited dismissed].sample }
    review do
      {
        id: generate(:review_id),
        node_id: Faker::Crypto.sha1,
        body: generate(:body),
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        state: generate(:review_state),
        submitted_at: submitted_at.to_time.iso8601
      }
    end
    changes do
      {
        body: generate(:body)
      }
    end
    initialize_with { attributes.deep_stringify_keys }

    trait :with_pull_request do
      pull_request { (build :pull_request_payload, repository: repository)['pull_request'] }
    end

    trait :with_repository do
      repository { (build :repository_payload)['repository'] }
    end

    factory :full_review_payload, traits: %i[with_repository with_pull_request]
  end
end
