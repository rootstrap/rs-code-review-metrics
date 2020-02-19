FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create
    repository do
      {
        id: rand(1000..1100),
        name: 'rs-code-review-metrics',
        description: ''
      }
    end
    initialize_with { attributes.deep_stringify_keys }
  end
end
