# == Schema Information
#
# Table name: events_pull_requests
#
#  id            :bigint           not null, primary key
#  body          :text
#  branch        :string
#  closed_at     :datetime
#  deleted_at    :datetime
#  draft         :boolean          not null
#  html_url      :string
#  locked        :boolean          not null
#  merged_at     :datetime
#  number        :integer          not null
#  opened_at     :datetime
#  size          :integer
#  state         :enum
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  github_id     :bigint           not null
#  node_id       :string           not null
#  owner_id      :bigint
#  repository_id :bigint
#
# Indexes
#
#  index_events_pull_requests_on_github_id      (github_id) UNIQUE
#  index_events_pull_requests_on_owner_id       (owner_id)
#  index_events_pull_requests_on_repository_id  (repository_id)
#  index_events_pull_requests_on_state          (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (repository_id => repositories.id)
#  fk_rails_...  (repository_id => repositories.id)
#

FactoryBot.define do
  sequence(:pull_request_id, 100)

  factory :pull_request, class: Events::PullRequest do
    github_id { generate(:pull_request_id) }
    number { Faker::Number.number(digits: 1) }
    title { "Pull Request-#{Faker::Number.number(digits: 1)}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }
    size { Faker::Number.within(range: 0..10_000) }
    state { 'open' }
    html_url { 'https://github.com/Codertocat/Hello-World/pull/2' }
    opened_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.now) }
    locked { false }
    draft { false }
    repository

    association :owner, factory: :user
  end
end
