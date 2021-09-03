# == Schema Information
#
# Table name: external_repositories
#
#  id          :bigint           not null, primary key
#  description :string
#  enabled     :boolean          default(TRUE), not null
#  full_name   :string           not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  github_id   :bigint           not null
#  language_id :bigint
#
# Indexes
#
#  index_external_repositories_on_language_id  (language_id)
#

FactoryBot.define do
  factory :external_repository do
    sequence(:github_id)
    description { Faker::FunnyName.name }
    name { Faker::App.name.gsub(' ', '') }
    full_name { "github/#{name}" }
    language { Language.unassigned }
  end
end
