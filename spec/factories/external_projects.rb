# == Schema Information
#
# Table name: external_projects
#
#  id          :bigint           not null, primary key
#  description :string
#  full_name   :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#
# Indexes
#
#  index_external_projects_on_language_id  (language_id)
#

FactoryBot.define do
  factory :external_project do
    description { Faker::FunnyName.name }
    name { Faker::App.name.gsub(' ', '') }
    full_name { "github/#{name}" }
    github_id { Faker::Number.number(digits: 10) }
    language { Language.unassigned }
  end
end
