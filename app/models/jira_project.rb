# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  project_id       :bigint
#
# Indexes
#
#  index_jira_projects_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

class JiraProject < ApplicationRecord
  belongs_to :project

  has_many :jira_issues

  validates :jira_project_key, presence: true, uniqueness: true
end
