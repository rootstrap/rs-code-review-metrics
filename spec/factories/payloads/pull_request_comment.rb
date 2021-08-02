FactoryBot.define do
  factory :pull_request_comment_payload, class: Hash do
    skip_create
    transient do
      body { generate(:body) }
      created_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
      updated_at { Faker::Date.between(from: created_at, to: Time.zone.now) }
    end

    action { %w[created edited deleted].sample }

    comment do
      {
        id: generate(:pull_request_comment_id),
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
    repository { build(:repository_payload) }
    issue do
      {
        id: Faker::Number.number(digits: 9),
        number: Faker::Number.number(digits: 1),
        title: "Pull Request-#{Faker::Number.number(digits: 1)}",
        node_id: "#{Faker::Alphanumeric.alphanumeric}=",
        html_url: 'https://github.com/Codertocat/Hello-World/pull/2',
        state: 'open',
        locked: 'false',
        user: (attributes_for :user, id: generate(:user_id)).as_json,
        created_at: created_at.to_time.iso8601,
        updated_at: updated_at.to_time.iso8601,
        pull_request: (build :pull_request_payload, repository: repository)['pull_request']
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
