# == Schema Information
#
# Table name: jira_environments
#
#  id                   :bigint           not null, primary key
#  custom_environment   :string           not null
#  standard_environment :integer          not null
#  jira_board_id        :bigint           not null
#
# Indexes
#
#  index_jira_environments_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

FactoryBot.define do
  factory :jira_environment do
    custom_environment { Faker::App.unique.name }

    trait :qa do
      standard_environment { :qa }
    end

    trait :development do
      standard_environment { :development }
    end

    trait :staging do
      standard_environment { :staging }
    end

    trait :production do
      standard_environment { :production }
    end
  end
end
