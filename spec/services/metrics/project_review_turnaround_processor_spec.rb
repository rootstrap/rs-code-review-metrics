require_relative 'metrics_specs_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor, type: :job do
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

  describe 'when processing a collection containing no review_events' do
    #  event :project, id: 'Project A', action: :created, at: '2019-01-01 15:10:00'
    #  event :pull_request, id: 1, project: 'Project A', action: :opened, at: '2020-01-01 15:10:00'
    #  event :anything_but :review, pull_request: 1
    let(:create_test_events) do
      pull_request_event_payload = create_pull_request_event(
        action: 'opened',
        created_at: Time.zone.parse('2020-01-01T15:10:00')
      )

      create_review_comment_event pull_request_event_payload: pull_request_event_payload
    end

    #  expect metrics count: 0
    it 'does not create a metric' do
      expect(generated_metrics_count).to eq(0)
    end
  end

  context 'for a project' do
    describe 'with a PR that had not been reviewed yet' do
      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #
      # Partial metric:
      #  event :pull_request, id: 1, project: 'Project A',
      #   action: :opened, at: '2020-01-01 15:10:00'
      let(:create_test_events) do
        create_pull_request_event action: 'opened',
                                  created_at: Time.zone.parse('2020-01-01T15:10:00')
      end

      # expect metrics_for project id: 'Project A', count: 0
      it 'does not generate a metric' do
        expect(generated_metrics_count).to eq(0)
      end
    end

    describe 'with no previous review_turnaround metric in the given time interval' do
      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #  event :pull_request, id: 1, project: 'Project A',
      #   action: :opened, at: '2020-01-01 15:10:00'
      #  event :review, pull_request: 1, action: :submitted,
      #   at: '2020-01-01 15:30:00'
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened',
          created_at: Time.zone.parse('2020-01-01T15:10:00')
        )

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: Time.zone.parse('2020-01-01T15:30:00')
      end

      # expect metrics_for project id: 'Project A', value: 20.minutes
      it 'generates a review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          entity_key: 'Project A',
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(20.minutes)
      end

      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #  event :pull_request, id: 1, project: 'Project A', action: :opened,
      #   at: '2020-01-01 15:10:00'
      #  event :review, pull_request_id: 1, action: :submitted,
      #   at: '2020-01-01 15:30:00'
      it 'generates only that metric' do
        # expect metrics count: 1
        expect(generated_metrics_count).to eq(1)
      end
    end

    describe 'with a previous review_turnaround metric in the given time interval' do
      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #
      # Partial metric:
      #  event :pull_request, id: 1, project: 'Project A',
      #   action: :opened, at: '2020-01-01 15:10:00'
      #  event :review, pull_request: 1, action: :submitted,
      #   at: '2020-01-01 15:30:00'
      #
      # Further events:
      #  event :pull_request, id: 1, project: 'Project A',
      #   action: :opened, at: '2020-01-01 16:00:00'
      #  event :review, pull_request: 1, action: :submitted,
      #   at: '2020-01-01 16:45:00'
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

      # expect metrics_for project id: 'Project A', value: 15.minutes
      it 'updates the review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          entity_key: 'Project A',
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(15.minutes)
      end

      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #  event :pull_request, id: 1, project: 'Project A', action: :opened,
      #   at: '2020-01-01 15:10:00'
      #  event :review, pull_request_id: 1, action: :submitted,
      #   at: '2020-01-01 15:30:00'
      it 'updates only that metric' do
        # expect metrics count: 1
        expect(generated_metrics_count).to eq(1)
      end
    end
  end
end
