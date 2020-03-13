# Project payload
FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create
    repository do
      {
        id: generate(:project_id),
        name: Faker::App.name,
        description: ''
      }
    end
    initialize_with { attributes.deep_stringify_keys }
  end
end
