# == Schema Information
#
# Table name: pull_requests
#
#  id         :bigint           not null, primary key
#  body       :text
#  closed_at  :datetime
#  draft      :boolean          not null
#  locked     :boolean          not null
#  merged     :boolean          not null
#  merged_at  :datetime
#  number     :integer          not null
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
#

FactoryBot.define do
  factory :pull_request do
    sequence(:github_id, 1000)
    sequence(:number, 2)
    sequence(:title) { |n| "Pull Request-#{n}" }
    node_id { 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3' }
    state { 'open' }
    merged { false }
    locked { false }
    draft { false }
  end
end
