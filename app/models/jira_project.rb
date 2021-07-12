# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class JiraProject < ApplicationRecord
  has_many :jira_issues, dependent: :destroy

  has_one :product, dependent: :destroy

  validates :jira_project_key, presence: true, uniqueness: true
end
