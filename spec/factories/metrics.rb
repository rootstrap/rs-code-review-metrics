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
    entity_key { 'generis' }
    metric_key { 'review_turnaround' }
    value { 495 }
    value_timestamp { Time.utc(2020, 2, 1, 0, 0, 0) }
  end
end
