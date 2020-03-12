# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
#  opened_at  :datetime
#  state      :enum
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  github_id  :bigint           not null
#  node_id    :string           not null
#
# Indexes
#
#  index_pull_requests_on_github_id  (github_id) UNIQUE
#  index_pull_requests_on_state      (state)
#

FactoryBot.define do
  factory :pull_request, class: Events::PullRequest do
    github_id { Faker::Number.unique.number(digits: 4) }
    number { Faker::Number.number(digits: 1) }
    title { "Pull Request-#{Faker::Number.number(digits: 1)}" }
    node_id { "#{Faker::Alphanumeric.alphanumeric}=" }
    state { 'opened' }
    locked { false }
    draft { false }
  end
end
