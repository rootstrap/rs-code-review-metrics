FactoryBot.define do
  factory :review_comment_payload, class: Hash do
    skip_create
    transient do
      body { generate(:body) }
      created_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
      updated_at { Faker::Date.between(from: created_at, to: Time.zone.now) }
    end

    comment do
      {
        id: generate(:review_comment_id),
        body: body,
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        created_at: created_at.iso8601,
        updated_at: updated_at.iso8601
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
