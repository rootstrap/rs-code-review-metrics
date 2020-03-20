# == Schema Information
#
# Table name: metrics
#
#  id                    :bigint           not null, primary key
#  entity_key            :string           not null
#  metric_key            :string           not null
#  value                 :decimal(, )
#  value_timestamp       :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  metrics_definition_id :bigint           not null
#
# Indexes
#
#  index_metrics_on_metrics_definition_id  (metrics_definition_id)
#
# Foreign Keys
#
#  fk_rails_...  (metrics_definition_id => metrics_definitions.id)
#

FactoryBot.define do
  factory :metric do
    entity_key { Faker::Name.unique }
    metric_key { Faker::Name.unique }
    value { Faker::Number.number(digits: 4) }
    value_timestamp { Faker::Date.backward(days: 30) }
    association :metrics_definition
  end
end
