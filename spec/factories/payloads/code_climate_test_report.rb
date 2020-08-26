FactoryBot.define do
  factory :code_climate_test_report_payload, class: Hash do
    skip_create

    transient do
      id { Faker::Alphanumeric.alphanumeric(number: 24) }
      coverage { Faker::Number.decimal(l_digits: 2, r_digits: 10) }
    end

    data do
      {
        id: id,
        type: 'test_reports',
        attributes: {
          branch: 'develop',
          commit_sha: 'db36165a645accc5ac78d3c70dffffa4aef7d8a2',
          committed_at: '2017-07-14T20:00:26.765Z',
          covered_percent: coverage,
          lines_of_code: 456,
          rating: {
            letter: 'A',
            measure: {
              value: coverage,
              unit: 'percent'
            }
          }
        }
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
