# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  jira_project_key :string           not null
#  projects_id      :bigint           not null
#
# Indexes
#
#  index_jira_projects_on_projects_id  (projects_id)
#
# Foreign Keys
#
#  fk_rails_...  (projects_id => projects.id)
#

FactoryBot.define do
  factory :jira_project do
    association :project

    jira_project_key { Faker::App.name }
  end
end
