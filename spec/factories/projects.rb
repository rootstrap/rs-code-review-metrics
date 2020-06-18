# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  description   :string
#  lang          :enum             default("unassigned")
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint
#  github_id     :integer          not null
#
# Indexes
#
#  index_projects_on_department_id  (department_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#

FactoryBot.define do
  sequence(:project_id, 100)

  factory :project do
    github_id { generate(:project_id) }
    name { Faker::App.name }
    description { Faker::FunnyName.name }
    lang { %w[ruby python nodejs react ios android others unassigned].sample }
  end
end
