# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  is_private  :boolean
#  name        :string
#  relevance   :enum             default("unassigned"), not null
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
    name { Faker::App.name.gsub(' ', '') }
    description { Faker::FunnyName.name }
    language { Language.unassigned }
    is_private { false }

    trait :open_source do
      language { Language.find_by(name: 'ruby') }
      relevance { Project.relevances[:internal] }
      is_private { false }
    end
  end
end
