# == Schema Information
#
# Table name: jira_issues
#
#  id              :bigint           not null, primary key
#  environment     :enum
#  informed_at     :datetime         not null
#  issue_type      :enum             not null
#  jira_project_id :bigint           not null
#
# Indexes
#
#  index_jira_issues_on_jira_project_id  (jira_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_project_id => jira_projects.id)
#

FactoryBot.define do
  factory :jira_issue do
    informed_at { Faker::Date.between(from: 2.days.ago, to: Date.today) }
    sequence(:issue_type) { |n| %w[bug task story epic][n % 4] }
    sequence(:environment) { |n| %w[no_env n/a local development qa staging production][n % 7] }

    association :jira_project
  end
end
