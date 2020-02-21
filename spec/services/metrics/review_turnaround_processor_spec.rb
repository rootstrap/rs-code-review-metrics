require 'rails_helper'

RSpec.describe Metrics::ReviewTurnaroundProcessor, type: :job do
  subject { Metrics::ReviewTurnaroundProcessor }

  let(:project) { create :project, name: 'Project A' }

  let(:review_request) { create :review_request }

  let(:create_one_review_event) do
    create :event, name: 'pull_request', project: project, handleable: review_request
  end

  let(:events_to_process) { Event.all }

  let(:generated_metrics) { Metric.all }

  let(:generated_metrics_count) { generated_metrics.size }

  describe 'for an empty collection of events to process' do
    before do
      create_one_review_comment_event
    end

    let(:review_comment) { create :review_comment }

    let(:create_one_review_comment_event) do
      create :event, name: 'review_comment', project: project, handleable: review_comment
    end

    it 'does not create a metrics' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(0)
    end
  end

  describe 'for a project that has no previous review_turnaround generated' do
    before do
      create_one_review_event
    end

    it 'generates a new metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value: 3600,
        value_timestamp: nil
      )
    end

    it 'generates only that metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(1)
    end
  end

  describe 'for a project that has a previous review_turnaround generated' do
    before(:each) do
      create_one_review_event
      subject.call(events: events_to_process)
    end

    it 'updates the metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value: 3600,
        value_timestamp: nil
      )
    end

    it 'does not generate a new metric' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(1)
    end
  end

  describe 'for two different projects' do
    before do
      create_one_review_event
      create_one_review_event_for_another_project
    end

    let(:another_project) { create :project, name: 'Project B' }

    let(:create_one_review_event_for_another_project) do
      create :event, name: 'pull_request', project: another_project, handleable: review_request
    end

    it 'generates a new metric for the first project' do
      subject.call(events: events_to_process)

      expect(generated_metrics.first).to have_attributes(
        entity_key: 'Project A',
        metric_key: 'review_turnaround',
        value: 3600,
        value_timestamp: nil
      )
    end

    it 'generates a new metric for the second project' do
      subject.call(events: events_to_process)

      expect(generated_metrics.second).to have_attributes(
        entity_key: 'Project B',
        metric_key: 'review_turnaround',
        value: 3600,
        value_timestamp: nil
      )
    end

    it 'generates only those two metrics' do
      subject.call(events: events_to_process)

      expect(generated_metrics_count).to eq(2)
    end
  end
end
