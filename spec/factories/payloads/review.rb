FactoryBot.define do
  factory :review_payload, class: Hash do
    skip_create
    review do
      {
        id: Faker::Number.number(digits: 4),
        body: Faker::Quote.singular_siegler,
        user: (attributes_for :user, id: Faker::Number.number).as_json
      }
    end
    changes do
      {
        body: Faker::Quote.singular_siegler
      }
    end
    initialize_with { attributes.deep_stringify_keys }

    factory :full_review_payload do
      after(:create) do |review_payload|
        review_payload.merge!((create :pull_request_payload))
        review_payload.merge!((create :repository_payload))
      end
    end
  end
end
