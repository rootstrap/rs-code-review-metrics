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
    repository { (build :repository_payload)['repository'] }
    pull_request { (build :pull_request_payload, repository: repository)['pull_request'] }

    initialize_with { attributes.deep_stringify_keys }
  end
end
