# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  private     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#  language_id :bigint
#
# Indexes
#
#  index_projects_on_language_id  (language_id)
#

FactoryBot.define do
  factory :project do
    sequence(:github_id, 1000)
    name { Faker::App.name }
    description { Faker::FunnyName.name }
    language { Language.find_by(name: 'unassigned') }
  end
end
