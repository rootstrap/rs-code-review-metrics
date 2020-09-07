# Project payload
FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create

    id { Faker::Number.number(digits: 4) }
    name { Faker::App.name }
    description { '' }
    private { false }
    archived { false }
    html_url { 'https://github.com/Codertocat/Hello-World/pull/2' }
    owner do
      {
        login: Faker::Name.name
      }
    end
    initialize_with { attributes.deep_stringify_keys }
  end
end
