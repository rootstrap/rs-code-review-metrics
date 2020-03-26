require_relative '../../support/helpers/metrics_specs_helper'

RSpec.describe Metrics::MetricsDefinitionProcessor do
  include_context 'events metrics'

  subject { described_class }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name
    end

    it 'creates and calls a MetricDefinitionTimeIntervalsProcessor to process the metrics' do
      expect(Metrics::MetricDefinitionTimeIntervalsProcessor).to receive(:call)
        .once

      subject.call
    end
  end
end
