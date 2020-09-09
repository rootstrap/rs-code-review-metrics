FactoryBot.define do
  factory :pull_request_payload, class: Hash do
    skip_create

    transient do
      created_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
      updated_at { Faker::Date.between(from: created_at, to: Time.zone.now) }
      branch { Faker::Company.bs.gsub(' ', '_').underscore }
      merged { false }
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
        html_url: 'https://github.com/Codertocat/Hello-World/pull/2',
        state: 'open',
        locked: 'false',
        draft: 'false',
        merged: merged,
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        created_at: created_at.to_time.iso8601,
        updated_at: updated_at.to_time.iso8601,
        head: {
          ref: branch
        }
      }
    end
    requested_reviewer do
      (attributes_for :review_request, id: generate(:review_request_id),
                                       node_id: "#{Faker::Alphanumeric.alphanumeric}=",
                                       login: "octocat#{Faker::Number.number}").as_json
    end
    initialize_with { attributes.deep_stringify_keys }

    factory :full_pull_request_payload do
      after(:build) do |pull_request_payload|
        pull_request_payload['repository'] = create(:repository_payload)
      end
    end
  end
end
