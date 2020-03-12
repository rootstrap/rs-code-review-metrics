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
    let(:events) { Event.all }

    context 'with no events to process' do
      it 'does not call any concrete MetricProcessor service' do
        expect(Metrics::NullProcessor).not_to receive(:new)

        subject.call(metrics_definition: metrics_definition, events: [])
      end
    end

    context 'with events to process' do
      before do
        create :event
      end
      let(:processed_event_time) { Event.first.created_at }

      it 'creates and calls the concrete MetricProcessor service' do
        expect(Metrics::NullProcessor).to receive(:call)

        subject.call(metrics_definition: metrics_definition, events: events)
      end

      it 'updates the metric last_processed_event_time after processing the metric' do
        subject.call(metrics_definition: metrics_definition, events: events)

        expect(metrics_definition.last_processed_event_time).to eql(processed_event_time)
      end
    end

    context 'with events that were processed before' do
      before do
        create :event
      end
      let(:process_events_for_the_first_time) do
        subject.call(metrics_definition: metrics_definition, events: events)
      end
      let(:process_events_for_the_second_time) do
        subject.call(metrics_definition: metrics_definition, events: events)
      end

      it 'does not process the event again' do
        process_events_for_the_first_time

        expect(Metrics::NullProcessor).to receive(:call)

        process_events_for_the_second_time
      end
    end
  end
end
