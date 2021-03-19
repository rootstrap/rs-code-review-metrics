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
  enum issue_types: { bug: 'bug', task: 'task', epic: 'epic', story: 'story' }
  enum environments: { not_assigned: 'not_assigned', local: 'local', development: 'development', qa: 'qa', staging: 'staging', production: 'production' }

  belongs_to :jira_project

  validates :informed_at, presence: true
  validates :issue_type, presence: true
  validates :issue_type, inclusion: { in: issue_types.keys }
  validates :environment, inclusion: { in: environments.keys }

  scope :bugs, -> { where(issue_type: 'bug') }
end
