require 'rails_helper'

<<<<<<< HEAD:spec/services/metrics/review_turnaround_per_user_project_processor_spec.rb
RSpec.describe Metrics::ReviewTurnaroundPerUserProjectProcessor do
=======
RSpec.describe Metrics::ReviewTurnaround::PerProject do
>>>>>>> changes the folder structure in order to have a better organization when new metrics get implemented:spec/services/metrics/review_turnaround/per_project_spec.rb
  include_context 'events metrics'

  subject { described_class }

  let(:time_interval_to_process) do
    TimeInterval.new(starting_at: (Time.zone.now - 1.hour).change(usec: 0),
                     duration: 1.day)
  end

  let(:first_user_project_id) { UsersProject.first.id }
  let(:second_user_project_id) { UsersProject.second.id }

  describe 'when processing a collection containing no review_events' do
    let(:create_test_events) do
      pull_request_event_payload = create_pull_request_event(
        action: 'opened'
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
          action: 'opened'
        )

        create_review_request_event(pull_request_event_payload: pull_request_event_payload)

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: (Time.zone.now - 30.minutes).change(usec: 0)
      end

      it 'generates a review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          ownable_id: first_user_project_id,
          value_timestamp: time_interval_to_process.starting_at
        )

        expect(first_metric_value_expressed_as_seconds).to eq(30.minutes)
      end

      it 'generates only that metric' do
        expect { process_all_events }.to change { Metric.count }.from(0).to(1)
      end
    end

    describe 'if a metric for the given time interval was already generated' do
      let(:create_test_events) do
        pull_request_event_payload = create_pull_request_event(
          action: 'opened'
        )

        create_review_request_event(pull_request_event_payload: pull_request_event_payload)

        create_review_event pull_request_event_payload: pull_request_event_payload,
                            action: 'submitted',
                            submitted_at: (Time.zone.now - 15.minutes).change(usec: 0)
      end

      before do
        pull_request2_event_payload = create_pull_request_event(
          action: 'opened'
        )

        create_review_request_event(pull_request_event_payload: pull_request2_event_payload)

        create_review_event pull_request_event_payload: pull_request2_event_payload,
                            action: 'submitted',
                            submitted_at: (Time.zone.now - 15.minutes).change(usec: 0)

        process_all_events_for_the_second_time
      end

      it 'updates the review_turnaround metric for the given interval' do
        expect(first_metric).to have_attributes(
          ownable_id: first_user_project_id,
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
            action: 'opened'
          )

          create_review_request_event(pull_request_event_payload: pull_request_event_payload)

          create_review_event pull_request_event_payload: pull_request_event_payload,
                              action: 'submitted',
                              submitted_at: (Time.zone.now - 20.minutes).change(usec: 0)

          create_review_event pull_request_event_payload: pull_request_event_payload,
                              action: 'submitted',
                              submitted_at: (Time.zone.now - 20.minutes).change(usec: 0)
        end

        it 'it uses only the first review to calculate the metric value' do
          expect(first_metric_value_expressed_as_seconds).to eq(20.minutes)
        end
      end
    end
  end

  describe 'with a PR that has no reviews' do
    let(:create_test_events) do
      create_pull_request_event(action: 'opened')
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
        action: 'opened'
      )

      create_review_request_event(pull_request_event_payload: pull_request_a_event_payload)

      create_review_event pull_request_event_payload: pull_request_a_event_payload,
                          action: 'submitted',
                          submitted_at: (Time.zone.now - 20.minutes).change(usec: 0)

      pull_request_b_event_payload = create_pull_request_event(
        repository_payload: test_repository_b_payload,
        action: 'opened'
      )

      create_review_request_event(pull_request_event_payload: pull_request_b_event_payload,
                                  user_id: 1000)

      create_review_event pull_request_event_payload: pull_request_b_event_payload,
                          action: 'submitted',
                          user_id: 1000,
                          submitted_at: (Time.zone.now - 45.minutes).change(usec: 0)
    end

    it 'it generates the metric for the first project' do
      expect(first_metric).to have_attributes(
        value_timestamp: time_interval_to_process.starting_at
      )

      expect(first_metric_value_expressed_as_seconds).to eq(20.minutes)
    end

    it 'it generates the metric for the second project' do
      expect(second_metric).to have_attributes(
        ownable_id: second_user_project_id,
        value_timestamp: time_interval_to_process.starting_at
      )

      expect(second_metric_value_expressed_as_seconds).to eq(45.minutes)
    end
  end
end
