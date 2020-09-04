FactoryBot.define do
  factory :pull_request_file_payload, class: Hash do
    skip_create

    sha { Faker::Alphanumeric.alphanumeric(number: 40) }
    filename { Faker::File.file_name }
    status { %w[added modified removed].sample }
    additions { Faker::Number.within(range: 0..1000) }
    deletions { Faker::Number.within(range: 0..1000) }
    changes { Faker::Number.within(range: 0..1000) }

    initialize_with { attributes.deep_stringify_keys }
  end
end
