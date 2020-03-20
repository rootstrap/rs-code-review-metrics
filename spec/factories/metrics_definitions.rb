# == Schema Information
#
# Table name: metrics_definitions
#
#  id                        :bigint           not null, primary key
#  last_processed_event_time :datetime
#  metrics_name              :string           not null
#  metrics_processor         :string           not null
#  subject                   :string           not null
#  time_interval             :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryBot.define do
  factory :metrics_definition do
    metrics_name { Faker::IndustrySegments.unique }
    time_interval { MetricsDefinition.time_intervals.keys.sample }
    subject { MetricsDefinition.subjects.keys.sample }
    metrics_processor { Metrics::NullProcessor }
    last_processed_event_time { nil }
  end
end
