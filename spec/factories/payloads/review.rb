FactoryBot.define do
  factory :review_payload, class: Hash do
    skip_create
    review do
      {
        id: rand(1000..1100),
        body: 'Please fix this.',
        user: (attributes_for :user, id: rand(1..1000)).as_json
      }
    end
    changes do
      {
        body: 'Please don\'t fix this.'
      }
    end
    initialize_with { attributes.deep_stringify_keys }
  end
end
