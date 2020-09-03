FactoryBot.define do
  factory :github_api_client_repositories_payload, class: Hash do
    skip_create

    sequence(:id)
    name { Faker::App.name.gsub(' ', '') }
    full_name { "#{name}/#{Faker::App.name.gsub(' ', '')}" }
    description { Faker::FunnyName.name }
    owner do
      {
        login: Faker::Internet.username
      }
    end

    initialize_with { [attributes.deep_stringify_keys] }
  end
end
