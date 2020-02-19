FactoryBot.define do
  factory :pull_request_payload, class: Hash do
    skip_create
    pull_request { {
      id: rand(1000..1100),
      number: rand(1..100),
      title: "Pull Request-#{rand(1..100)}",
      node_id: 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3',
      state: 'open',
      locked: 'false',
      draft: 'false',
      user: (attributes_for :user, id: rand(1..1000)).as_json
    } }
    requested_reviewer { (attributes_for :review_request, id: rand(1..1000)).as_json }
    initialize_with { attributes.deep_stringify_keys }
  end
end
