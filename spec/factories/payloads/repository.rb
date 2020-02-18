FactoryBot.define do
  factory :repository_payload, class: Hash do
    skip_create
    repository { {
      id: rand(1000..1100),
      name: 'rs-code-review-metrics',
      description: ''
    } }
    initialize_with { attributes.deep_stringify_keys }
  end
end
