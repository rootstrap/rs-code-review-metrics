# == Schema Information
#
# Table name: jira_issues
#
#  id              :bigint           not null, primary key
#  environment     :enum
#  informed_at     :datetime         not null
#  issue_type      :enum             not null
#  key             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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

class JiraIssue < ApplicationRecord
  enum issue_type: { bug: 'bug', task: 'task', epic: 'epic', story: 'story' }
  enum environment: {
    local: 'local',
    development: 'development',
    qa: 'qa',
    staging: 'staging',
    production: 'production'
  }

  belongs_to :jira_project

  validates :informed_at, :issue_type, presence: true
end
