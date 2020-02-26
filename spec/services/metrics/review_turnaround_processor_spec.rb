require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor, type: :job do
  subject { Metrics::ReviewTurnaroundProcessor }

  let(:project) { create :project, name: 'Project A' }

  let(:create_one_review_event) do
    create :event, :of_type_review, project: project
  end

  let(:events_to_process) { Event.all }

  let(:create_test_events) {}

  let(:generated_metrics) { Metric.all }

  let(:generated_metrics_count) { generated_metrics.size }

  before do
    create_test_events
  end

  describe 'when processing a collection containing no review_event' do
    let(:review_comment) { create :review_comment }

    let(:create_test_events) do
      create :event, name: 'review_comment', project: project, handleable: review_comment
    end

    it 'does not create a metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(0)
    end
  end

  describe 'for a project that had not previously processed the review_turnaround metric' do
    let(:create_test_events) do
      create_one_review_event
    end

    it 'generates a first review_turnaround metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value_timestamp: nil
      )

      # Fix this: use the event time, not the model creation time
      expect(generated_metrics.first.value).to be_within(1) .of(0)
    end

    it 'generates only that metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(1)
    end
  end

  describe 'for a project that had previously processed the review_turnaround metric' do
    let(:generate_previous_review_turnaround) do
      subject.call(events: events_to_process)
    end

    let(:create_test_events) do
      create_one_review_event
      generate_previous_review_turnaround
    end

    it 'updates the metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value_timestamp: nil
      )

      # Fix this: use the event time, not the model creation time
      expect(generated_metrics.first.value).to be_within(1) .of(0)
    end

    it 'does not generate a new metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(1)
    end
  end

  describe 'for two different projects' do
    let(:another_project) { create :project, name: 'Project B' }

    let(:create_one_review_event_for_another_project) do
      create :event, :of_type_review, project: another_project
    end

    let(:create_test_events) do
      create_one_review_event
      create_one_review_event_for_another_project
    end

    it 'generates a new metric for the first project' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value_timestamp: nil
      )

      # Fix this: use the event time, not the model creation time
      expect(generated_metrics.first.value).to be_within(1) .of(0)
    end

    it 'generates a new metric for the second project' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value_timestamp: nil
      )

      # Fix this: use the event time, not the model creation time
      expect(generated_metrics.first.value).to be_within(1) .of(0)
    end

    it 'generates only those two metrics' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(2)
    end
  end
end
