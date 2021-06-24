require 'rails_helper'

RSpec.describe Processors::JiraProjectDefectEscapeRateUpdater do
  describe '#call' do
    let(:project) { create(:project) }
    let(:project_key) { 'TES' }
    let!(:jira_project) { create(:jira_project, project: project, jira_project_key: project_key) }
    let(:subject) { described_class.call(jira_project) }
    let(:bugs) do
      [
        {
          'key': 'TES-4',
          'fields': {
            'customfield': [{ 'value': 'production' }],
            'created': '2021-03-14T15:48:04.000-0300'
          }
        }
      ]
    end
    let(:payload) { { issues: bugs } }

    before { stub_get_bugs_ok(payload, project_key) }

    context 'when there are not already returned bugs available' do
      it 'creates a record on the db' do
        expect { subject }.to change { JiraIssue.count }.from(0).to(1)

        expect(JiraIssue.last.jira_project).to eq(jira_project)
        expect(JiraIssue.last.informed_at).to eq('2021-03-14T15:48:04.000-0300')
        expect(JiraIssue.last.environment).to eq('production')
      end
    end

    context 'when there are bugs returned previously' do
      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraIssue.count }
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
