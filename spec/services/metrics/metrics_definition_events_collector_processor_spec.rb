require_relative '../../support/metrics_specs_helper'

RSpec.describe Metrics::MetricsDefinitionsEventsCollector do
  include_context 'events metrics'

  subject { described_class }

  let(:metrics_definitions) { MetricsDefinition.all }
  let(:up_to_time) { Time.zone.now }
  let(:events) do
    subject.call(metrics_definitions: metrics_definitions,
                 up_to: up_to_time)
  end

  describe 'with an empty set of MetricsDefinition' do
    it 'returns an empty collection of events' do
      expect(events).to be_empty
    end
  end

  describe 'with an empty set of events' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name
    end

    it 'returns an empty collection of events' do
      expect(events).to be_empty
    end
  end

  describe 'with events for one MetricsDefinition' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name

      create_pull_request_event(
        action: 'opened',
        created_at: Time.zone.parse('2020-01-01T15:10:00')
      )
    end

    it 'returns the collection of events' do
      expect(events).to have(1).item
    end
  end

  describe 'with more than one event to collect' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name

      create_pull_request_event(
        action: 'opened',
        created_at: newest_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: oldest_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: older_event_time
      )
    end

    let(:oldest_event_time) { Time.zone.parse('2020-01-01T15:10:00') }
    let(:older_event_time) { Time.zone.parse('2020-01-02T15:10:00') }
    let(:newest_event_time) { Time.zone.parse('2020-01-03T15:10:00') }

    it 'returns the collection ordered by each event.occurred_at time' do
      expect(events.first.occurred_at).to eq(oldest_event_time)
      expect(events.second.occurred_at).to eq(older_event_time)
      expect(events.third.occurred_at).to eq(newest_event_time)
    end
  end

  describe 'with events prior to a metrics_definition.last_processed_event_time' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name,
             last_processed_event_time: oldest_last_processed_event_time

      create_pull_request_event(
        action: 'opened',
        created_at: oldest_last_processed_event_time
      )

      create_pull_request_event(
        action: 'opened',
        created_at: newest_last_processed_event_time
      )
    end

    let(:oldest_last_processed_event_time) { Time.zone.parse('2020-01-01T15:10:00') }
    let(:newest_last_processed_event_time) { Time.zone.parse('2020-01-02T15:10:00') }

    it 'returns only the events after the last_processed_event_time' do
      expect(events).to have(1).item
      expect(events.first.occurred_at).to eq(newest_last_processed_event_time)
    end
  end

  describe 'with more than one MetricsDefinition' do
    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name,
             last_processed_event_time: newest_last_processed_event_time

      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name,
             last_processed_event_time: oldest_last_processed_event_time

      create_pull_request_event(
        action: 'opened',
        created_at: newest_last_processed_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: older_last_processed_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: oldest_last_processed_event_time
      )
    end

    let(:oldest_last_processed_event_time) { Time.zone.parse('2020-01-01T15:10:00') }
    let(:older_last_processed_event_time) { Time.zone.parse('2020-01-02T15:10:00') }
    let(:newest_last_processed_event_time) { Time.zone.parse('2020-01-03T15:10:00') }

    it 'returns the events from the oldest last_processed_event_time' do
      expect(events).to have(2).item
    end
  end

  describe 'with an up_to time given' do
    let(:up_to_time) { older_event_time }

    before do
      create :metrics_definition,
             metrics_name: 'review_turnaround',
             time_interval: :daily,
             subject: :projects,
             metrics_processor: Metrics::NullProcessor.name

      create_pull_request_event(
        action: 'opened',
        created_at: newest_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: oldest_event_time
      )
      create_pull_request_event(
        action: 'opened',
        created_at: older_event_time
      )
    end

    let(:oldest_event_time) { Time.zone.parse('2020-01-01T15:10:00') }
    let(:older_event_time) { Time.zone.parse('2020-01-02T15:10:00') }
    let(:newest_event_time) { Time.zone.parse('2020-01-03T15:10:00') }

    it 'returns the events occurred up to the given time, including it' do
      expect(events).to have(2).item
      expect(events.first.occurred_at).to eq(oldest_event_time)
      expect(events.second.occurred_at).to eq(older_event_time)
    end
  end
end
