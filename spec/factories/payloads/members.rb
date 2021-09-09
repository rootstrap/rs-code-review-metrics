# Repository payload
FactoryBot.define do
  factory :members_payload, class: Hash do
    skip_create

    id { Faker::Number.number(digits: 4) }
    login { Faker::App.name }

    initialize_with { attributes.deep_stringify_keys }
  end
end
