FactoryBot.define do
  factory :github_api_client_pull_request_event_payload, class: Hash do
    skip_create

    transient do
      pull_request { nil }
      username { Faker::Internet.username }
    end

    sequence(:id)
    type { 'PullRequestEvent' }
    created_at { (1..24).to_a.sample.hours.ago }

    payload do
      {
        pull_request: build(
          :github_api_client_pull_request_payload,
          pull_request: pull_request,
          username: username,
          merged: true
        )
      }
    end

    repo do
      {
        id: id,
        name: "#{Faker::App.name.gsub(' ', '')}/#{Faker::App.name.gsub(' ', '')}"
      }
    end

    actor do
      {
        login: username
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
