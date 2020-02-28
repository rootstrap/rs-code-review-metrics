require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor, type: :job do
  subject { Metrics::ReviewTurnaroundProcessor }

  # RFC where should these methods be defined? The make reference to :subject
  def events_to_process
    Event.all
  end

  def process_all_events
    subject.call(events: events_to_process,
                 time_interval: time_interval_to_process)
  end

  def generated_metrics
    Metric.all
  end

  def generated_metrics_count
    Metric.count
  end

  def first_metric
    Metric.first
  end

  def first_metric_value_expressed_as_seconds
    first_metric.value.seconds
  end

  def second_metric
    Metric.second
  end

  def second_metric_value_expressed_as_seconds
    second_metric.value.seconds
  end

  let(:time_interval_to_process) do
    TimeInterval.new(starting_at: Time.zone.parse('2020-01-01 00:00:00'),
                     duration: 1.day)
  end

  let(:create_test_events) {}

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
             pull_request_payload: pull_request.data['pull_request']
    end

    #  expect metrics count: 0
    it 'does not create a metric' do
      expect(generated_metrics_count).to eq(0)
    end
  end

  context 'for a project' do
    let(:project_a) { create :project, name: 'Project A' }

    describe 'with no previous review_turnaround metric in the given time interval' do
      #  event :project, id: 10, action: :created, at: '2019-01-01 15:10:00'
      #  event :pull_request, id: 1, project: 'Project A',
      #   action: :opened, at: '2020-01-01 15:10:00'
      #  event :review, pull_request: 1, action: :submitted,
      #   at: '2020-01-01 15:30:00'
      let(:create_test_events) do
        pull_request = create :event_pull_request,
                              project: project_a,
                              action: 'opened',
                              created_at: Time.zone.parse('2020-01-01T15:10:00')
        create :event_review,
               project: project_a,
               submitted_at: Time.zone.parse('2020-01-01T15:30:00'),
               pull_request_payload: pull_request.data['pull_request']
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
        pull_request = create :event_pull_request,
                              project: project_a,
                              action: 'opened',
                              created_at: Time.zone.parse('2020-01-01T15:10:00')
        create :event_review,
               project: project_a,
               submitted_at: Time.zone.parse('2020-01-01T15:30:00'),
               pull_request_payload: pull_request.data['pull_request']
      end

      before do
        pull_request_2 = create :event_pull_request,
                              project: project_a,
                              action: 'opened',
                              created_at: Time.zone.parse('2020-01-01T16:00:00')
        create :event_review,
               project: project_a,
               submitted_at: Time.zone.parse('2020-01-01T16:10:00'),
               pull_request_payload: pull_request_2.data['pull_request']

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
