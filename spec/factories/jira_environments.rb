# == Schema Information
#
# Table name: jira_environments
#
#  id                 :bigint           not null, primary key
#  custom_environment :string
#  deleted_at         :datetime
#  environment        :enum             not null
#  jira_board_id      :bigint
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
    custom_environment { Faker::Name.name }
    sequence(:environment) { |n| %w[development qa staging production][n % 4] }
    
    association :jira_board

    trait :qa do
      environment { :qa }
    end

    trait :development do
      environment { :development }
    end

    trait :staging do
      environment { :staging }
    end

    trait :production do
      environment { :production }
    end

  end
end
