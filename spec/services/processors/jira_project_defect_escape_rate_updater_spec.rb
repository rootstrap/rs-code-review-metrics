require 'rails_helper'

RSpec.describe Processors::JiraProjectDefectEscapeRateUpdater do
  describe '#call' do
    let(:product) { create(:product) }
    let(:project_key) { 'TES' }
    let!(:jira_board) { create(:jira_board, product: product, jira_project_key: project_key) }
    let!(:jira_environment_prod) { create(:jira_environment, :production, jira_board: jira_board) }
    let!(:jira_environment_qa) { create(:jira_environment, :qa, jira_board: jira_board) }
    let!(:jira_environment_development) do
      create(:jira_environment, :development,
             jira_board: jira_board)
    end
    let!(:jira_environment_staging) { create(:jira_environment, :staging, jira_board: jira_board) }

    let(:last_issue) { JiraIssue.last }
    let(:informed_at_date) { '22021-03-14T15:48:04.000-0300' }
    let(:in_progress_date) { '2021-03-17T15:48:04.000-0300' }
    let(:resolved_at_date) { '2021-03-19T17:30:04.000-0300' }
    let(:subject) { described_class.call(jira_board) }

    let(:fields) do
      [
        {
          'id': 'customfield_10000',
          'name': 'env_test'
        },
        {
          'id': 'customfield_2000',
          'name': 'other_env_test'
        }
      ]
    end

    let(:payload_field) { { fields: fields } }

    before { stub_get_field_ok(payload_field) }

    let(:bugs) do
      [
        {
          'key': 'TES-4',
          'fields': {
            'customfield_10000': [{ 'value': 'custom_production' }],
            'created': informed_at_date
          }
        }
      ]
    end
    let(:payload) { { issues: bugs } }

    before { stub_get_bugs_ok(payload, project_key) }

    context 'when there are not already returned bugs available' do
      it 'creates a record on the db' do
        expect { subject }.to change { JiraIssue.count }.from(0).to(1)
      end

      it 'is associated to the project' do
        subject
        expect(last_issue.jira_board).to eq(jira_board)
      end

      it 'is set the environment' do
        subject
        expect(last_issue.environment).to eq('production')
      end

      it 'is set the issue type' do
        subject
        expect(last_issue.issue_type).to eq('bug')
      end

      it 'is set the informed at date' do
        subject
        expect(last_issue.informed_at).to eq(informed_at_date)
      end

      context 'when the environment needs to be parsed from QA' do
        let(:bugs) do
          [
            {
              'key': 'TES-4',
              'fields': {
                'customfield_10000': [{ 'value': 'custom_qa' }],
                'created': informed_at_date
              }
            }
          ]
        end
        it 'is set the qa environment' do
          subject
          expect(last_issue.environment).to eq('qa')
        end
      end

      context 'when the environment needs to be parsed from development' do
        let(:bugs) do
          [
            {
              'key': 'TES-4',
              'fields': {
                'customfield_10000': [{ 'value': 'custom_development' }],
                'created': informed_at_date
              }
            }
          ]
        end
        it 'is set the development environment' do
          subject
          expect(last_issue.environment).to eq('development')
        end
      end

      context 'when the environment needs to be parsed from staging' do
        let(:bugs) do
          [
            {
              'key': 'TES-4',
              'fields': {
                'customfield_10000': [{ 'value': 'custom_staging' }],
                'created': informed_at_date
              }
            }
          ]
        end
        it 'is set the staging environment' do
          subject
          expect(last_issue.environment).to eq('staging')
        end
      end

      context 'when the environment needs to be parsed from production' do
        let(:bugs) do
          [
            {
              'key': 'TES-4',
              'fields': {
                'customfield_10000': [{ 'value': 'custom_production' }],
                'created': informed_at_date
              }
            }
          ]
        end
        it 'is set the production environment' do
          subject
          expect(last_issue.environment).to eq('production')
        end
      end
    end

    context 'when there are bugs returned previously' do
      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraIssue.count }
      end
    end

    context 'when the bug is changed to In Progress' do
      let(:bugs) do
        [
          {
            'key': 'TES-4',
            'fields': {
              'customfield_10000': [{ 'value': 'production' }],
              'created': informed_at_date,
              'resolutiondate': resolved_at_date
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

      it 'updates the in progress date' do
        subject
        expect(last_issue.in_progress_at).to eq(in_progress_date)
      end
    end

    context 'when the bug is done' do
      let(:bugs) do
        [
          {
            'key': 'TES-4',
            'fields': {
              'customfield_10000': [{ 'value': 'production' }],
              'created': informed_at_date,
              'resolutiondate': resolved_at_date
            }
          }
        ]
      end

      it 'is updated the resolution date' do
        subject
        expect(last_issue.resolved_at).to eq(resolved_at_date)
      end
    end

    context 'when there are not bugs to report' do
      let(:bugs) { [] }

      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraIssue.count }
      end
    end
  end
end
