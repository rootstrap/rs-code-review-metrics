# == Schema Information
#
# Table name: external_pull_requests
#
#  id                  :bigint           not null, primary key
#  body                :text
#  html_url            :string           not null
#  opened_at           :datetime
#  title               :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_project_id :bigint           not null
#  github_id           :bigint
#  owner_id            :bigint
#
# Indexes
#
#  index_external_pull_requests_on_external_project_id  (external_project_id)
#  index_external_pull_requests_on_owner_id             (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_project_id => external_projects.id)
#  fk_rails_...  (owner_id => users.id)
#

FactoryBot.define do
  factory :external_pull_request do
    sequence(:github_id)
    html_url { 'https://github.com/Codertocat/Hello-World/pull/2' }
    title { "Pull Request-#{Faker::Number.number(digits: 1)}" }
    association :external_project
    owner { association :user }
  end
end
