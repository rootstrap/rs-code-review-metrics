require_relative '../../support/helpers/metrics_specs_helper'

RSpec.describe Metrics::ReviewTurnaroundPerProjectProcessor do
  include_context 'events metrics'

  subject { described_class }

  let(:time_interval_to_process) do
    TimeInterval.new(starting_at: Time.zone.parse('2020-01-01 00:00:00'),
                     duration: 1.day)
  end

  let(:first_project_id) { Project.order(:id).first.id.to_s }
  let(:second_project_id) { Project.order(:id).second.id.to_s }

  describe 'when processing a collection containing no review_events' do
    let(:create_test_events) do
      pull_request_event_payload = create_pull_request_event(
        action: 'opened',
        created_at: Time.zone.parse('2020-01-01T15:10:00')
      )

      create_review_comment_event(pull_request_event_payload: pull_request_event_payload)
    end

    it 'does not create a metric' do
      expect { process_all_events }.not_to change { Metric.count }
    end
  end

  context 'when generating the metric values' do
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
          entity_key: first_project_id,
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to eq(20.minutes)
      end

      it 'generates only that metric' do
        expect { process_all_events }.to change { Metric.count }.from(0).to(1)
      end

      it 'updates the metric last_processed_event_time' do
        expect {
          process_all_events
        }.to change { metrics_definition.last_processed_event_time }
          .from(nil).to(Events::Review.last.created_at)
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

        process_all_events_for_the_second_time
      end

      it 'updates the review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          entity_key: first_project_id,
          metric_key: 'review_turnaround',
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to eq(15.minutes)
      end

      it 'does not create a new metric' do
        expect { process_all_events }.not_to change { Metric.count }
      end
    end

    context 'when calculating the turnaround value' do
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
          expect(first_metric_value_expressed_as_seconds).to eq(20.minutes)
        end
      end
    end
  end

  describe 'with a PR that has no reviews' do
    let(:create_test_events) do
      create_pull_request_event(action: 'opened',
                                created_at: Time.zone.parse('2020-01-01T15:10:00'))
    end

    it 'does not generate a metric' do
      expect { process_all_events }.not_to change { Metric.count }
    end
  end

  describe 'with events from more than one project' do
    let(:test_repository_b_payload) do
      (build :repository_payload, name: 'Project B')['repository']
    end

    let(:create_test_events) do
      pull_request_a_event_payload = create_pull_request_event(
        action: 'opened',
        created_at: Time.zone.parse('2020-01-01T15:10:00')
      )

      create_review_event pull_request_event_payload: pull_request_a_event_payload,
                          action: 'submitted',
                          submitted_at: Time.zone.parse('2020-01-01T15:30:00')

      pull_request_b_event_payload = create_pull_request_event(
        repository_payload: test_repository_b_payload,
        action: 'opened',
        created_at: Time.zone.parse('2020-01-01T16:00:00')
      )

      create_review_event repository_payload: test_repository_b_payload,
                          pull_request_event_payload: pull_request_b_event_payload,
                          action: 'submitted',
                          submitted_at: Time.zone.parse('2020-01-01T16:45:00')
    end

    it 'it generates the metric for the first project' do
      expect(first_metric).to have_attributes(
        entity_key: first_project_id,
        metric_key: 'review_turnaround',
        value_timestamp: time_interval_to_process.starting_at
      )

      expect(first_metric_value_expressed_as_seconds).to eq(20.minutes)
    end

    it 'it generates the metric for the second project' do
      expect(second_metric).to have_attributes(
        entity_key: second_project_id,
        metric_key: 'review_turnaround',
        value_timestamp: time_interval_to_process.starting_at
      )

      expect(second_metric_value_expressed_as_seconds).to eq(45.minutes)
    end
  end
end
