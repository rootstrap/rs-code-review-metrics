FactoryBot.define do
  factory :repository_views_payload, class: Hash do
    skip_create

    count { Faker::Number.number(digits: 3) }
    uniques { Faker::Number.number(digits: 3) }

    views do
      now = Time.zone.now
      [
        now - 2.weeks,
        now.last_week,
        now
      ].map(&:beginning_of_week).map do |timestamp|
        {
          'timestamp': timestamp.iso8601,
          'count': Faker::Number.number(digits: 2),
          'uniques': Faker::Number.number(digits: 2)
        }
      end
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
