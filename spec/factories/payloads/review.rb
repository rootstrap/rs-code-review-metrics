FactoryBot.define do
  factory :review_payload, class: Hash do
    skip_create

    transient do
      body { generate(:body) }
      submitted_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
      edited_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
      dismissed_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
    end

    action { %w[submitted edited dismissed].sample }
    review do
      {
        id: generate(:review_id),
        node_id: Faker::Crypto.sha1,
        body: body,
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
    pull_request { (build :pull_request_payload, repository: repository)['pull_request'] }
    repository { (build :repository_payload)['repository'] }

    initialize_with { attributes.deep_stringify_keys }

    after(:build) do |review, factory|
      review['review']['edited_at'] = factory.edited_at.iso8601 if factory.action == 'edited'
      review['review']['dismissed_at'] = factory.dismissed_at.iso8601 if factory.dismissed_at
    end
  end
end
