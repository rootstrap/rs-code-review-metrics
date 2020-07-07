FactoryBot.define do
  factory :repository_views_payload, class: Hash do
    skip_create

    count { Faker::Number.number(digits: 3) }
    uniques { Faker::Number.number(digits: 3) }

    views do
      start_date = 14.days.ago.to_date
      end_date = Time.zone.today.to_date
      (start_date..end_date).map(&:beginning_of_day).map do |timestamp|
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
