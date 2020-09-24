FactoryBot.define do
  factory :gitub_api_client_pull_requests_events_payload, class: Hash do
    skip_create

    sequence(:id)
    type { 'PullRequestEvent' }
    created_at { (1..24).to_a.sample.hours.ago }

    payload do
      {
        pull_request: {
          url: Faker::Internet.url,
          html_url: Faker::Internet.url,
          title: "Pull Request-#{Faker::Number.number(digits: 1)}",
          body: Faker::Lorem.paragraph
        }
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
        login: Faker::Internet.username
      }
    end

    initialize_with { [attributes.deep_stringify_keys] }
  end
end
