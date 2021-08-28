# == Schema Information
#
# Table name: jira_issues
#
#  id             :bigint           not null, primary key
#  deleted_at     :datetime
#  environment    :enum
#  in_progress_at :datetime
#  informed_at    :datetime         not null
#  issue_type     :enum             not null
#  key            :string
#  resolved_at    :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  jira_board_id  :bigint
#
# Indexes
#
#  index_jira_issues_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

class JiraIssue < ApplicationRecord
  acts_as_paranoid

  enum issue_type: { bug: 'bug', task: 'task', epic: 'epic', story: 'story' }
  enum environment: {
    local: 'local',
    development: 'development',
    qa: 'qa',
    staging: 'staging',
    production: 'production'
  }

  belongs_to :jira_board

  validates :informed_at, :issue_type, presence: true
end
