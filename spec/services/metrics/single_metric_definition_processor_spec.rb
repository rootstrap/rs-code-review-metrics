require_relative '../../support/metrics_specs_helper'

RSpec.describe Metrics::SingleMetricDefinitionProcessor do
  subject { described_class }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name
    end

    let(:metrics_definition) { MetricsDefinition.first }

    context 'with no events to process' do
      it 'does not call any concrete MetricProcessor service' do
        expect_any_instance_of(Metrics::NullProcessor).not_to receive(:call)

        subject.call(metrics_definition: metrics_definition, events: [])
      end
    end
  end
end
