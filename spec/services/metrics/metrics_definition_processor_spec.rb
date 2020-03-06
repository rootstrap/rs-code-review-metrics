require_relative '../../support/metrics_specs_helper'

RSpec.describe Metrics::MetricsDefinitionProcessor do
  subject { Metrics::MetricsDefinitionProcessor }

  describe 'when processing the defined metrics' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name
    end

    context 'with no events to process' do
      it 'does not instantiate the concrete metrics processor' do
        expect(Metrics::NullProcessor).not_to receive(:call)
      end
    end

    context 'with events to process' do
      before do
        create :event
      end

      let(:metrics_definition) { MetricsDefinition.first }

      let(:processed_event_time) { Event.first.created_at }

      it 'creates the concrete metrics processor to process the metrics' do
        expect_any_instance_of(Metrics::NullProcessor).to receive(:call).once

        subject.call
      end

      it 'updates the metric last_processed_event_time after processing the metric' do
        subject.call

        expect(metrics_definition.last_processed_event_time).to eql(processed_event_time)
      end
    end

    context 'with events that had been processed already' do
      before do
        create :event
      end

      it 'does not process the event again' do
        subject.call

        expect_any_instance_of(Metrics::NullProcessor).not_to receive(:call)

        subject.call
      end
    end
  end
end
