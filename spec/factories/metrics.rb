# == Schema Information
#
# Table name: metrics
#
#  id              :bigint           not null, primary key
#  entity_key      :string           not null
#  metric_key      :string           not null
#  value           :decimal(, )
#  value_timestamp :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :metric do
    entity_key { Faker::Name.unique }
    metric_key { Faker::Name.unique }
    value { Faker::Number.number(digits: 4) }
    value_timestamp { Faker::Date.backward(days: 30) }
  end
end
