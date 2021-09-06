# == Schema Information
#
# Table name: jira_boards
#
#  id               :bigint           not null, primary key
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  repository_id       :bigint
#
# Indexes
#
#  index_jira_repositories_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  fk_rails_...  (repository_id => repositories.id)
#

FactoryBot.define do
  factory :jira_board do
    project_name { Faker::Lorem.sentence }
    jira_project_key { Faker::App.unique.name }

    product

    trait :with_board_id do
      jira_board_id { Faker::Internet.uuid }
      jira_self_url { Faker::Internet.url }
    end

    trait :no_board_id do
      jira_board_id { nil }
      jira_self_url { nil }
    end
  end
end
