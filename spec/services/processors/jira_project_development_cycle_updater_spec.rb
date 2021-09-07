require 'rails_helper'

describe Processors::JiraProjectDevelopmentCycleUpdater do
  describe '#call' do
    let(:product) { create(:product) }
    let(:project_key) { 'TES' }
    let!(:jira_board) { create(:jira_board, product: product, jira_project_key: project_key) }
    let(:last_issue) { JiraIssue.last }
    let(:informed_at_date) { '2021-03-14T15:48:04.000-0300' }
    let(:in_progress_date) { '2021-03-17T15:48:04.000-0300' }
    let(:resolved_at_date) { '2021-03-19T17:30:04.000-0300' }
    let(:subject) { described_class.call(jira_board) }
    let(:bugs) do
      [
        {
          'key': 'TES-4',
          'fields': {
            'customfield_10000': [{ 'value': 'production' }],
            'created': informed_at_date,
            'issuetype': {
              'name': 'Task'
            }
          },
          'changelog': {
            'histories': [
              {
                'created': '2021-03-17T15:48:04.000-0300',
                'items': [
                  'fieldId': 'status',
                  'fromString': 'To Do',
                  'toString': 'In Progress'
                ]
              }
            ]
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
        expect(last_issue.jira_board).to eq(jira_board)
      end

      it 'is set the informed at date' do
        subject
        expect(last_issue.informed_at).to eq(informed_at_date)
      end

      it 'is set the environment' do
        subject
        expect(last_issue.environment).to eq('production')
      end

      it 'is set the issue type' do
        subject
        expect(last_issue.issue_type).to eq('task')
      end

      it 'sets in_progress_at date' do
        subject
        expect(last_issue.in_progress_at).to eq(in_progress_date)
      end

      it 'has no resolution date' do
        subject
        expect(last_issue.resolved_at).to be_nil
      end

      context 'when the issue type is not in the enum' do
        let(:bugs) do
          [
            {
              'key': 'TES-4',
              'fields': {
                'customfield_10000': [{ 'value': 'production' }],
                'created': informed_at_date,
                'resolutiondate': resolved_at_date,
                'issuetype': {
                  'name': 'test_execution'
                }
              }
            }
          ]
        end

        it 'does not creates a record in the db' do
          expect { subject }.not_to change(JiraIssue, :count)
        end
      end
    end

    context 'when the issue is done' do
      let(:bugs) do
        [
          {
            'key': 'TES-4',
            'fields': {
              'customfield_10000': [{ 'value': 'production' }],
              'created': informed_at_date,
              'resolutiondate': resolved_at_date,
              'issuetype': {
                'name': 'Task'
              }
            }
          }
        ]
      end

      let!(:jira_issue) do
        create(:jira_issue,
               informed_at: informed_at_date,
               in_progress_at: '2021-03-15T15:48:04.000-0300',
               issue_type: 'task',
               environment: 'production',
               jira_board: jira_board,
               key: 'TES-4')
      end

      it 'is updated the resolution date' do
        subject
        expect(last_issue.reload.resolved_at).to eq(resolved_at_date)
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
