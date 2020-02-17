FactoryBot.define do
  factory :metric do
    entity_key { 'generis' }
    metric_key { 'review_turnaround' }
    value { 495 }
    value_timestamp { Time.utc(2020,2,1,0,0,0) }
  end
end
