FactoryBot.define do
  factory :review_comment_payload, class: Hash do
    skip_create
    comment do
      {
        id: generate(:review_comment_id),
        body: generate(:body),
        user: (attributes_for :user, id: generate(:user_id)).as_json
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

    factory :full_review_comment_payload, traits: %i[with_repository with_pull_request]
  end
end
