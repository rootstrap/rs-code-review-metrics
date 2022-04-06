# == Schema Information
#
# Table name: jira_environments
#
#  id                 :bigint           not null, primary key
#  custom_environment :string
#  deleted_at         :datetime
#  environment        :enum             not null
#  jira_board_id      :bigint
#
# Indexes
#
#  index_jira_environments_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

class JiraEnvironment < ApplicationRecord


  belongs_to :jira_board
  validates :custom_environment, presence: true
  enum environment: {
    local: 'local',
    development: 'development',
    qa: 'qa',
    staging: 'staging',
    production: 'production'
  }
end
