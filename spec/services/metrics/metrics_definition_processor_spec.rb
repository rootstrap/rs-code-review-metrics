require_relative '../../support/metrics_specs_helper'

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

    let(:metrics_definition) { MetricsDefinition.first }

    context 'with no events to process' do
      it 'does not process any metrics_definition' do
        expect(Metrics::SingleMetricDefinitionProcessor).not_to receive(:new)

        subject.call
      end
    end

    context 'with events to process' do
      before do
        create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )
      end

      it 'creates and calls a Metrics::SingleMetricDefinitionProcessor to process the metrics' do
        expect(Metrics::SingleMetricDefinitionProcessor).to receive(:call)
          .once

        subject.call
      end
    end
  end
end
