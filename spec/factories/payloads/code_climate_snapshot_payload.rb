FactoryBot.define do
  factory :code_climate_snapshot_payload, class: Hash do
    skip_create

    transient do
      id { Faker::Number.number(digits: 4) }
      rate { 'C' }
      ratings { [{ 'letter': rate }] }
    end

    data do
      {
        'id' => id,
        'attributes' => {
          'commit_sha': 'db36165a645accc5ac78d3c70dffffa4aef7d8a2',
          'committed_at': '2017-07-14T20:00:26.765Z',
          'created_at': '2017-07-14T20:03:14.042Z',
          'lines_of_code': 456,
          'ratings' => ratings
        }
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
