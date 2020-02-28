FactoryBot.define do
  factory :check_run_payload, class: Hash do
    skip_create

    action { %w[created completed rerequested requested_action] }
    check_run do
      {
        id: Faker::Number.unique.number(digits: 4),
        node_id: "#{Faker::Alphanumeric.alphanumeric}="
      }
    end
    repository { (create :repository_payload)['repository'] }

    initialize_with { attributes.deep_stringify_keys }
  end
end
