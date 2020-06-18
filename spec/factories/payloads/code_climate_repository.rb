FactoryBot.define do
  factory :code_climate_repository_payload, class: Hash do
    skip_create

    transient do
      id { Faker::Number.number(digits: 4) }
      name { Faker::Internet.slug(glue: '-') }
      latest_default_branch_snapshot_id { Faker::Number.number(digits: 4) }
    end

    # Despite of the name this endpoint returns a collection of repositories:
    #   https://developer.codeclimate.com/#get-repository
    data do
      [
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
            }
          }
        }
      ]
    end

    initialize_with { attributes.deep_stringify_keys }
  end
end
