require 'rails_helper'

RSpec.describe Processors::MetricDefinitionTimeIntervals do
  subject { described_class }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             metrics_processor: Metrics::NullProcessor.name

      create :event_pull_request, occurred_at: Time.zone.now
    end

    let(:metrics_definition) { MetricsDefinition.first }

    it 'creates and calls the concrete MetricProcessor service' do
      expect(Metrics::NullProcessor).to receive(:call)

      subject.call(metrics_definition: metrics_definition)
    end
  end
end