FactoryBot.define do
  factory :review_comment_payload, class: Hash do
    skip_create
    comment do
      {
        id: Faker::Number.number(digits: 4),
        body: Faker::Quote.matz,
        user: (attributes_for :user, id: Faker::Number.number).as_json
      }
    end
    changes do
      {
        body: Faker::Quote.matz
      }
    end
    initialize_with { attributes.deep_stringify_keys }
  end
end
