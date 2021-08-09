require 'rails_helper'

describe Processors::JiraProjectDevelopmentCycleUpdater do
  describe '#call' do
    let(:project_key) { 'TES' }
    let(:product) { create(:product, jira_project_key: project_key) }
    let!(:project) { create(:project, product: product) }
    let(:last_issue) { JiraIssue.last }
    let(:subject) { described_class.call(product) }
    let(:bugs) do
      [
        {
          'key': 'TES-4',
          'fields': {
            'customfield_10000': [{ 'value': 'production' }],
            'created': '2021-03-14T15:48:04.000-0300',
            'issuetype': {
              'name': 'Task'
            },
            'status': {
              'name': 'In Progress'
            },
            'updated': '2021-03-15T15:48:04.000-0300'
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
        expect(last_issue.product).to eq(product)
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

      it 'is set in progress date' do
        subject
        expect(last_issue.in_progress_at).to eq('2021-03-15T15:48:04.000-0300')
      end

      it 'has no resolution date' do
        subject
        expect(last_issue.resolved_at).to be_nil
      end
    end

    context 'when the issue is done' do
      let(:bugs) do
        [
          {
            'key': 'TES-4',
            'fields': {
              'customfield_10000': [{ 'value': 'production' }],
              'created': '2021-03-14T15:48:00.000-0300',
              'resolutiondate': '2021-03-20T17:30:04.000-0300',
              'issuetype': {
                'name': 'Task'
              },
              'status': {
                'name': 'Done'
              },
              'updated': '2021-03-20T15:48:04.000-0300'
            }
          }
        ]
      end

      let!(:jira_issue) do
        create(:jira_issue,
               informed_at: '2021-03-14T15:48:00.000-0300',
               in_progress_at: '2021-03-15T15:48:04.000-0300',
               issue_type: 'task',
               environment: 'production',
               product: product,
               key: 'TES-4')
      end

      it 'is updated the resolution date' do
        subject
        expect(last_issue.reload.resolved_at).to eq('2021-03-20T17:30:04.000-0300')
      end

      it 'is not updated in progress date' do
        subject
        expect(last_issue.in_progress_at).to eq(jira_issue.in_progress_at)
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
