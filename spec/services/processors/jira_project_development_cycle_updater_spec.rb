require 'rails_helper'

describe Processors::JiraProjectDevelopmentCycleUpdater do
  describe '#call' do
    let(:product) { create(:product) }
    let(:project) { create(:project, product: product) }
    let(:project_key) { 'TES' }
    let!(:jira_project) { create(:jira_project, product: product, jira_project_key: project_key) }
    let(:last_issue) { JiraIssue.last }
    let(:subject) { described_class.call(jira_project) }
    let(:bugs) do
      [
        {
          'key': 'TES-4',
          'fields': {
            'customfield': [{ 'value': 'production' }],
            'created': '2021-03-14T15:48:04.000-0300',
            'issuetype': {
              'name': 'Task'
            }
          }
        }
      ]
    end
    let(:payload) { { issues: bugs } }

    before { stub_get_issues_ok(payload, project_key) }

    context 'when there are not already returned bugs available' do
      it 'creates a record on the db' do
        expect { subject }.to change { JiraIssue.count }.from(0).to(1)
      end

      it 'is associated to the project' do
        subject
        expect(last_issue.jira_project).to eq(jira_project)
      end

      it 'is set the informed at date' do
        subject
        expect(last_issue.informed_at).to eq('2021-03-14T15:48:04.000-0300')
      end

      it 'is set the environment' do
        subject
        expect(last_issue.environment).to eq('production')
      end

      it 'is set the issue type' do
        subject
        expect(last_issue.issue_type).to eq('task')
      end

      it 'has no resolution date' do
        subject
        expect(last_issue.resolved_at).to be_nil
      end
    end

    context 'when the issues is done' do
      let(:bugs) do
        [
          {
            'key': 'TES-4',
            'fields': {
              'customfield': [{ 'value': 'production' }],
              'created': '2021-03-14T15:48:00.000-0300',
              'resolutiondate': '2021-03-19T17:30:04.000-0300',
              'issuetype': {
                'name': 'Task'
              }
            }
          }
        ]
      end

      it 'is updated the resolution date' do
        subject
        expect(last_issue.resolved_at).to eq('2021-03-19T17:30:04.000-0300')
      end

      it 'creates development cycle metric' do
        expect { subject }.to change { Metric.count }.from(0).to(1)
      end

      it 'creates development cycle metric with correct value' do
        subject
        expect(Metric.last.value).to eq(last_issue.resolved_at - last_issue.informed_at)
      end
    end

    context 'when there are bugs returned previously' do
      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraIssue.count }
      end
    end

    context 'when there are not issues to report' do
      let(:bugs) { [] }

      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraIssue.count }
      end
    end
  end
end
