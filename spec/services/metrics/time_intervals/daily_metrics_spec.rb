require_relative '../../../support/metrics_specs_helper'

RSpec.describe Metrics::MetricDefinitionTimeIntervalsProcessor do
  subject { described_class }

  describe 'when processing daily metris' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name

      create :event_pull_request, occurred_at: Time.zone.now - 2.days
    end

    let(:metrics_definition) { MetricsDefinition.first }

    let(:first_daily_interval) do
      TimeIntervals::DailyInterval.containing(Time.zone.now - 2.days)
    end

    let(:second_daily_interval) do
      TimeIntervals::DailyInterval.containing(Time.zone.now - 1.day)
    end

    let(:third_daily_interval) do
      TimeIntervals::DailyInterval.containing(Time.zone.now)
    end

    it 'creates and calls the concrete MetricProcessor service' do
      expect(Metrics::NullProcessor).to receive(:call)
        .with(hash_including(time_interval: first_daily_interval))

      expect(Metrics::NullProcessor).to receive(:call)
        .with(hash_including(time_interval: second_daily_interval))

      expect(Metrics::NullProcessor).to receive(:call)
        .with(hash_including(time_interval: third_daily_interval))

      subject.call(metrics_definition: metrics_definition)
    end
  end
end
