FactoryBot.define do
  factory :review_comment_payload, class: Hash do
    skip_create
    comment { {
      id: rand(1000..1100),
      body: 'Please fix this.',
      user: (attributes_for :user, id: rand(1..1000)).as_json
    } }
    changes { {
      body: 'Please don\'t fix this.'
    } }
    initialize_with { attributes.deep_stringify_keys }
  end
end
