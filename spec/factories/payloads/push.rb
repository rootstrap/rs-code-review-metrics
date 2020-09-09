FactoryBot.define do
  factory :push_payload, class: Hash do
    skip_create

    transient do
      branch { Faker::Company.bs.gsub(' ', '_').underscore }
      repository_id { Faker::Number.number(digits: 4) }
    end

    ref { "refs/heads/#{branch}" }
    repository { create(:repository_payload, id: repository_id) }
    sender { (attributes_for :user, id: generate(:user_id)).as_json }

    initialize_with { attributes.deep_stringify_keys }
  end
end
