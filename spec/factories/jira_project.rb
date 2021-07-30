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

FactoryBot.define do
  factory :jira_project do
    project_name { Faker::Lorem.sentence }
    jira_project_key { Faker::App.unique.name }

    product
  end
end
