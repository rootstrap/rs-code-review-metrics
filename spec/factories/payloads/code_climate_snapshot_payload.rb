FactoryBot.define do
  factory :code_climate_snapshot_payload, class: Hash do
    skip_create

    transient do
      id { Faker::Number.number(digits: 4) }
      rate { 'C' }
    end

    data do
      {
        'id' => id,
        'attributes' => {
          'ratings' => [
            {
              'letter' => rate
            }
          ]
        }
      }
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
