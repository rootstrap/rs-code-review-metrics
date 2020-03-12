require_relative '../../support/metrics_specs_helper'

RSpec.describe Metrics::MetricsDefinitionProcessor do
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
        create :event
      end

      let(:processed_event_time) { Event.first.created_at }

      it 'creates and calls a Metrics::SingleMetricDefinitionProcessor to process the metrics' do
        expect(Metrics::SingleMetricDefinitionProcessor).to receive(:call)
          .once

        subject.call
      end

      it 'updates the metric last_processed_event_time after processing the metric' do
        subject.call

        expect(metrics_definition.last_processed_event_time).to eql(processed_event_time)
      end
    end

    context 'with events that were processed before' do
      before do
        create :event
      end

      let(:process_events_for_the_first_time) { subject.call }
      let(:process_events_for_the_second_time) { subject.call }

      it 'does not process the event again' do
        process_events_for_the_first_time

        expect(Metrics::SingleMetricDefinitionProcessor).not_to receive(:new)

        process_events_for_the_second_time
      end
    end
  end
end
