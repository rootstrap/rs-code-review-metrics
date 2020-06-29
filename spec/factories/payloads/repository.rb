# Project payload
FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create
    transient do
      id { Faker::Number.number(digits: 4) }
      name { Faker::App.name }
      description { '' }
      is_private { false }
    end

    repository do
      {
        id: id,
        name: name,
        description: description,
        private: is_private
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
