FactoryBot.define do
  factory :pull_request_payload, class: Hash do
    skip_create

    transient do
      created_at { Faker::Date.between(from: 1.month.ago, to: Date.yesterday) }
      updated_at { Faker::Date.between(from: created_at, to: Date.yesterday) }
    end

    action do
      %w[assigned unassigned review_requested review_request_removed
         labeled unlabeled opened edited closed ready_for_review locked
         unlocked reopened].sample
    end
    pull_request do
      {
        id: generate(:pull_request_id),
        number: Faker::Number.number(digits: 1),
        title: "Pull Request-#{Faker::Number.number(digits: 1)}",
        node_id: "#{Faker::Alphanumeric.alphanumeric}=",
        state: 'open',
        locked: 'false',
        draft: 'false',
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        created_at: created_at.to_time.iso8601,
        updated_at: updated_at.to_time.iso8601
      }
    end
    requested_reviewer do
      (attributes_for :review_request, id: generate(:review_request_id)).as_json
    end
    initialize_with { attributes.deep_stringify_keys }

    factory :full_pull_request_payload do
      after(:create) do |pull_request_payload|
        pull_request_payload['repository'] = (create :repository_payload)['repository']
      end
    end
  end
end
