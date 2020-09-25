FactoryBot.define do
  factory :github_api_client_pull_request_payload, class: Hash do
    skip_create

    transient do
      base_repo { create(:repository_payload) }
    end

    sequence(:id)
    url { Faker::Internet.url }
    html_url { Faker::Internet.url }
    number { Faker::Number.number(digits: 3) }
    title { "Pull Request-#{Faker::Number.number(digits: 1)}" }
    user do
      {
        login: Faker::Internet.username
      }
    end
    body { Faker::Lorem.paragraph }
    base do
      {
        repo: base_repo
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
