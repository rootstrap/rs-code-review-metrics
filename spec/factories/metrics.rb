# == Schema Information
#
# Table name: metrics
#
#  id              :bigint           not null, primary key
#  interval        :enum             default("daily")
#  name            :enum
#  ownable_type    :string           not null
#  value           :decimal(, )
#  value_timestamp :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ownable_id      :bigint           not null
#
# Indexes
#
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#

FactoryBot.define do
  factory :metric do
    value { Faker::Number.number(digits: 4) }
    interval { 'daily' }
    name { 'review_turnaround' }
    value_timestamp { Time.zone.now }

    association :ownable, factory: :project

    factory :weekly_metric do
      interval { 'weekly' }
      value_timestamp { Time.zone.today.benning_of_week }
    end
  end

  trait :for_user do
    association :ownable, factory: :user
  end
end
