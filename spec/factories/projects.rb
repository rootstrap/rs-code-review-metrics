# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :string
#  lang        :enum             default("unassigned")
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :integer          not null
#

FactoryBot.define do
  factory :project do
    github_id { Faker::Number.unique.number(digits: 4) }
    name { Faker::App.name }
    description { Faker::FunnyName.name }
    lang { %w[ruby python nodejs react ios android others unassigned].sample }
  end
end
