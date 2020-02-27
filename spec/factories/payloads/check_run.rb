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
    initialize_with { attributes.deep_stringify_keys }

    trait :with_repository do
      repository { (create :repository_payload)['repository'] }
    end
  end
end
