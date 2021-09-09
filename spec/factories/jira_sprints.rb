# == Schema Information
#
# Table name: jira_sprints
#
#  id               :bigint           not null, primary key
#  active           :boolean
#  deleted_at       :datetime
#  ended_at         :datetime
#  name             :string
#  points_committed :integer
#  points_completed :integer
#  started_at       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jira_board_id    :bigint           not null
#  jira_id          :integer          not null
#
# Indexes
#
#  index_jira_sprints_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

FactoryBot.define do
  sequence(:sprint_id, 1000)

  factory :jira_sprint do
    active            { false }
    name              { Faker::App.unique.name }
    jira_id           { generate(:sprint_id) }
    points_committed  { Faker::Number.number(digits: 2) }
    points_completed  { Faker::Number.between(from: 1, to: 99) }

    started_at        { Faker::Date.between(from: 1.month.ago, to: Time.zone.today) }
    ended_at          { Time.zone.today }

    association :jira_board
  end
end
