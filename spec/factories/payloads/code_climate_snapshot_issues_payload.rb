FactoryBot.define do
  factory :code_climate_snapshot_issues_payload, class: Hash do
    skip_create

    transient do
      status { ['invalid'] }
    end

    data do
      status.map do |each_status|
        {
          'id' => Faker::Number.number(digits: 10),
          'attributes' => {
            'status' => {
              'name' => each_status
            }
          }
        }
      end
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
