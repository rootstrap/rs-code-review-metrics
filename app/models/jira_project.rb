# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
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
  acts_as_paranoid

  belongs_to :project

  has_many :jira_issues, dependent: :destroy

  validates :jira_project_key, presence: true, uniqueness: true
end
