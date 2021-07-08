# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  description     :string
#  name            :string           not null
#  jira_project_id :bigint
#
# Indexes
#
#  index_products_on_jira_project_id  (jira_project_id)
#  index_products_on_name             (name)
#
# Foreign Keys
#
#  fk_rails_...  (jira_project_id => jira_projects.id)
#

FactoryBot.define do
  factory :product do
    name { Faker::Name.name.gsub(' ', '') }
    description { Faker::Lorem.sentence }

    jira_project
  end
end
