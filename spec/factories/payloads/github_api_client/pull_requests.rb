FactoryBot.define do
  factory :github_api_client_pull_request_payload, class: Hash do
    skip_create

    transient do
      pull_request { nil }
      username { Faker::Internet.username }
      base_repo { build(:repository_payload) }
    end

    id { pull_request&.github_id || generate(:pull_request_id) }
    url { Faker::Internet.url }
    html_url { pull_request&.html_url || Faker::Internet.url }
    number { pull_request&.number || Faker::Number.number(digits: 3) }
    title { pull_request&.title || "Pull Request-#{Faker::Number.number(digits: 1)}" }
    user do
      {
        id: generate(:user_id),
        login: pull_request&.owner&.login || username,
        node_id: "#{Faker::Alphanumeric.alphanumeric}="
      }
    end
    body { pull_request&.body || Faker::Lorem.paragraph }
    base do
      {
        repo: base_repo
      }
    end
    created_at { (1..24).to_a.sample.hours.ago.iso8601 }
    state { 'open' }
    merged { false }

    initialize_with { attributes.deep_stringify_keys }
  end
end
