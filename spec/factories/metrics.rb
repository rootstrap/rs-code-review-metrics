# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  interval              :enum
#  name                  :enum
#  ownable_type          :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#  ownable_id            :bigint           not null
#
# Indexes
#
#  index_metrics_on_ownable_type_and_ownable_id  (ownable_type,ownable_id)
#

FactoryBot.define do
  factory :metric do
    value { Faker::Number.number(digits: 4) }
    sequence(:name) { |n| Metric.names.values[n % 1] }
    sequence(:interval) { |n| Metric.intervals.values[n % 4] }

    association :ownable, factory: :project
  end

  trait :for_user do
    association :ownable, factory: :user
  end
end
