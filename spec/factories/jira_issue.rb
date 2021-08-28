# == Schema Information
#
# Table name: jira_issues
#
#  id              :bigint           not null, primary key
#  environment     :enum
#  informed_at     :datetime         not null
#  issue_type      :enum             not null
#  key             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  jira_board_id :bigint           not null
#
# Indexes
#
#  index_jira_issues_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

FactoryBot.define do
  factory :jira_issue do
    informed_at { Faker::Date.between(from: 1.month.ago, to: Time.zone.today) }
    sequence(:issue_type) { |n| %w[bug task story epic][n % 4] }
    sequence(:environment) { |n| %w[local development qa staging production][n % 7] }

    association :jira_board

    trait :bug do
      issue_type { 'bug' }
    end

    trait :production do
      environment { 'production' }
    end

    trait :qa do
      environment { 'qa' }
    end

    trait :staging do
      environment { 'staging' }
    end

    trait :no_environment do
      environment { nil }
    end

    after(:build) do |jira_issue|
      jira_issue.key { "#{jira_issue.jira_board.jira_project_key}-#{Faker::Number.digits(3)}" }
    end
  end
end
