require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor, type: :job do
  subject { Metrics::ReviewTurnaroundProcessor }

  let(:events_to_process) { Event.all }

  let(:time_span_to_process) { 1.day }

  let(:start_time_to_process) { Time.zone.parse('2020-01-01 00:00:00') }

  let(:process_all_events) do
    subject.call(events: events_to_process, starting_at: start_time_to_process, time_span: time_span_to_process)
  end

  let(:create_test_events) {}

  let(:generated_metrics) { Metric.all }

  let(:generated_metrics_count) { Metric.count }

  let(:first_metric) { generated_metrics.first }
  let(:first_metric_value_expressed_as_seconds) { first_metric.value.seconds }

  let(:second_metric) { generated_metrics.second }
  let(:second_metric_value_expressed_as_seconds) { second_metric.value.seconds }

  before do
    create_test_events
    process_all_events
  end

  describe 'when processing a collection containing no review_events' do
    #  event :project, id: 'Project A', action: :created, at: '2019-01-01 15:10:00'
    #  event :pull_request, id: 1, project: 'Project A', action: :opened, at: '2020-01-01 15:10:00'
    #  event :anything_but :review, pull_request: 1
    let(:create_test_events) do
      project_a = create :project, name: 'Project A'
      pull_request = create :event_pull_request,
                            project: project_a,
                            action: 'opened',
                            created_at: Time.zone.parse('2020-01-01 15:10:00')
      create :event_review_comment,
             pull_request_payload: (pull_request.data['pull_request'])
    end

    #  expect metrics count: 0
    it 'does not create a metric' do
      expect(generated_metrics_count).to eq(0)
    end
  end

  describe 'for a project that had not previously processed the review_turnaround metric' do
    #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
    #  event :pull_request, id: 1, project: 'Project A', action: :opened, at: '2020-01-01 15:10:00'
    #  event :review, pull_request: 1, action: :submitted, , at: '2020-01-01 15:30:00'
    let(:create_test_events) do
      project_a = create :project, name: 'Project A'
      pull_request = create :event_pull_request,
                            project: project_a,
                            action: 'opened',
                            created_at: Time.zone.parse('2020-01-01T15:10:00')
      create :event_review,
             project: project_a,
             submitted_at: Time.zone.parse('2020-01-01T15:30:00'),
             pull_request_payload: (pull_request.data['pull_request'])
    end

    # expect metrics_for pull_request id: 1, value: 20.minutes
    it 'generates a review_turnaround metric' do
      expect(first_metric).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value_timestamp: start_time_to_process
      )

      expect(first_metric_value_expressed_as_seconds).to be_within(1.second) .of(20.minutes)
    end

    #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
    #  event :pull_request, id: 1, project: 'Project A', action: :opened, at: '2020-01-01 15:10:00'
    #  event :review, pull_request_id: 1, action: :submitted, , at: '2020-01-01 15:30:00'
    it 'generates only that metric' do
      # expect metrics count: 1
      expect(generated_metrics_count).to eq(1)
    end
  end
end
