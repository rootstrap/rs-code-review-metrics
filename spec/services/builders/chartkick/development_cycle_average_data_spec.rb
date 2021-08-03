require 'rails_helper'

describe Builders::Chartkick::DevelopmentCycleAverageData do
  subject { described_class.send(:new, 1, '') }

  describe '.build_data' do
    context 'for a given set of metrics' do
      let(:first_week) { '2021-07-19'.to_date }
      let(:this_week) { '2021-07-26'.to_date }
      let(:formatted_first_week) { first_week.strftime('%Y-%m-%d') }
      let(:formatted_this_week) { this_week.strftime('%Y-%m-%d') }

      let(:jira_project) { create(:jira_project) }

      let(:jira_issue1) do
        create(:jira_issue,
               informed_at: '2021-07-12T15:48:00.000-0300',
               in_progress_at: '2021-07-19T15:48:04.000-0300',
               resolved_at: '2021-07-21T15:48:04.000-0300',
               issue_type: 'task',
               environment: 'development',
               jira_project: jira_project)
      end

      let(:jira_issue2) do
        create(:jira_issue,
               informed_at: '2021-07-12T15:48:00.000-0300',
               in_progress_at: '2021-07-26T15:48:04.000-0300',
               resolved_at: '2021-07-30T15:48:04.000-0300',
               issue_type: 'task',
               environment: 'development',
               jira_project: jira_project)
      end

      let(:average_last_week) { (jira_issue1.resolved_at - jira_issue1.in_progress_at) / 1.day }
      let(:average_this_week) { (jira_issue2.resolved_at - jira_issue2.in_progress_at) / 1.day }

      let(:average) do
        (((jira_issue1.resolved_at - jira_issue1.in_progress_at) +
        (jira_issue2.resolved_at - jira_issue2.in_progress_at)) / 1.day) / 2
      end

      let(:value_for_last_week) do
        {
          development_cycle: average_last_week
        }
      end
      let(:value_for_this_week) do
        {
          development_cycle: average_this_week
        }
      end
      let(:metric_for_last_week) { Metrics::Base::Metric.new(1, first_week, value_for_last_week) }
      let(:metric_for_this_week) { Metrics::Base::Metric.new(1, this_week, value_for_this_week) }
      let(:metrics) { [metric_for_this_week, metric_for_last_week] }
      let(:expected_hash_value) do
        {
          average: average
        }
      end

      it 'returns the expected hash value' do
        expect(subject.build_data(metrics)).to eq(expected_hash_value)
      end
    end
  end
end
