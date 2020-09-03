FactoryBot.define do
  factory :gitub_api_client_pull_requests_payload, class: Hash do
    skip_create

    id  { Faker::Number.number(digits: 9) }
    url { Faker::Internet.url }
    html_url { Faker::Internet.url }
    title { "Pull Request-#{Faker::Number.number(digits: 1)}" }
    user do
      {
        login: Faker::Internet.username
      }
    end
    body { Faker::Lorem.paragraph }

    initialize_with { [attributes.deep_stringify_keys] }
  end
end
