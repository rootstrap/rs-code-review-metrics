require_relative 'metrics_specs_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor do
  subject { Metrics::ReviewTurnaroundProcessor }

  let(:test_repository_payload) do
    (build :repository_payload, name: 'Project A')['repository']
  end

  let(:create_test_events) {}

  let(:time_interval_to_process) do
    TimeInterval.new(starting_at: Time.zone.parse('2020-01-01 00:00:00'),
                     duration: 1.day)
  end

  before do
    create_test_events
    process_all_events
  end

  context 'no review_turnaround events' do
    describe 'when processing a collection containing no review_events' do
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )

        create_review_comment_event pull_request_event_payload: pull_request_event_payload
      end

      it 'does not create a metric' do
        expect(generated_metrics_count).to eq(0)
      end
    end
  end

  context 'metrics generation' do
    describe 'if the metrics for the given time interval was not yet generated' do
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T15:30:00')
      end

      it 'generates a review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          entity_key: 'Project A',
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(20.minutes)
      end

      it 'generates only that metric' do
        expect(generated_metrics_count).to eq(1)
      end
    end

    describe 'if a metric for the given time interval was already generated' do
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T15:30:00')
      end

      before do
        pull_request2_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T16:00:00')
        )

        create_review_event pull_request_event_payload: pull_request2_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T16:10:00')

        # process the metrics again with the new events
        process_all_events
      end

      it 'updates the review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          entity_key: 'Project A',
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(15.minutes)
      end

      it 'does not create a new metric' do
        expect(generated_metrics_count).to eq(1)
      end
    end
  end

  context 'review turnaround definition' do
    describe 'if a pull request has more than one review' do
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T15:30:00')

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T16:30:00')
      end

      it 'it uses only the first review to calculate the metric value' do
        expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(20.minutes)
      end
    end
  end

  describe 'with a PR that has no reviews' do
    let(:create_test_events) do
      create_pull_request_event(action: 'opened',
                                created_at: Time.zone.parse('2020-01-01T15:10:00'))
    end

    it 'does not generate a metric' do
      expect(generated_metrics_count).to eq(0)
    end
  end
end
