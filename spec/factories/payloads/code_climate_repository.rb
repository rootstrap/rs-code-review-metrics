FactoryBot.define do
  factory :code_climate_repository_payload,
          aliases: [:code_climate_repository_by_id_payload],
          class: Hash do
    skip_create

    transient do
      id { Faker::Alphanumeric.alphanumeric(number: 24) }
      name { Faker::Internet.slug(glue: '-') }
      latest_default_branch_snapshot_id { Faker::Number.number(digits: 4) }
      latest_default_branch_test_report_id { Faker::Alphanumeric.alphanumeric(number: 24) }
      repository_payload do
        {
          'id' => id,
          'type' => 'repos',
          'attributes' => {
            'analysis_version' => 3385,
            'badge_token' => '16096d266f46b7c68dd4',
            'branch' => 'master',
            'created_at' => '2017-07-15T20:08:03.732Z',
            'github_slug' => name,
            'human_name' => name,
            'last_activity_at' => '2017-07-15T20:09:41.846Z',
            'vcs_database_id' => '92872343',
            'vcs_host' => 'https://github.com',
            'score' => 1.36
          },
          'relationships' => {
            'latest_default_branch_snapshot' => {
              'data' => {
                'id' => latest_default_branch_snapshot_id,
                'type' => 'snapshots'
              }
            },
            'latest_default_branch_test_report' => {
              'data' => {
                'id' => latest_default_branch_test_report_id,
                'type' => 'test_reports'
              }
            }
          }
        }
      end
    end

    data { repository_payload }

    initialize_with { attributes.deep_stringify_keys }

    factory :code_climate_repository_by_slug_payload, class: Hash do
      # Despite of the name this endpoint returns a collection of repositories:
      #   https://developer.codeclimate.com/#get-repository
      after(:build) do |payload|
        payload['data'] = [payload['data']].compact
      end
    end
  end
end
