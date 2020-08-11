# Project payload
FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create

    id { Faker::Number.number(digits: 4) }
    name { Faker::App.name }
    description { '' }
    private { false }

    initialize_with { attributes.deep_stringify_keys }
  end
end
