# == Schema Information
#
# Table name: jira_environments
#
#  id                   :bigint           not null, primary key
#  custom_environment   :string           not null
#  standard_environment :integer          not null
#  jira_board_id        :bigint           not null
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
  validates :custom_environment,:standard_environment, presence: true
  enum standar_environment: { qa: 0, development: 1, staging: 2, production: 3 }
end
