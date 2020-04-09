require 'rails_helper'

RSpec.describe Processors::MetricsDefinition do
  include_context 'events metrics'

  subject { described_class }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             metrics_processor: Metrics::NullProcessor.name
    end

    it 'creates and calls a MetricDefinitionTimeIntervalsProcessor to process the metrics' do
      expect(Processors::MetricDefinitionTimeIntervals).to receive(:call)
        .once

      subject.call
    end
  end
end
