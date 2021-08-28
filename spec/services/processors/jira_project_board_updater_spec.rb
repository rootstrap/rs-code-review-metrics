require 'rails_helper'

describe Processors::JiraProjectBoardUpdater do
  describe '#call' do
    let(:product) { create(:product) }
    let(:project_key) { 'TES' }
    let(:jira_project) do
      create(:jira_board,
             :no_board_id,
             product: product,
             jira_project_key: project_key)
    end
    let(:subject) { described_class.call(jira_project) }
    let(:detail) do
      [
        {
          'id': 1,
          'self': 'https://name.atlassian.net/rest/agile/1.0/board/1',
          'name': 'TestEM (TES)',
          'type': 'simple',
          'location': {
            'projectId': 10_068,
            'displayName': 'TestEM (TES)',
            'projectName': 'TestEM',
            'projectKey': 'TES',
            'projectTypeKey': 'software',
            'avatarURI': '/secure/projectavatar?size=small&s=small&pid=10068&avatarId=10401',
            'name': 'TestEM (TES)'
          }
        }
      ]
    end
    let(:payload) { { values: detail } }

    before { stub_get_board_ok(payload, project_key) }

    context 'when there is no board id yet' do
      it 'is set the board id' do
        subject
        expect(jira_project.jira_board_id).to eq(1)
      end
      it 'is set the url' do
        subject
        expect(jira_project.jira_self_url)
          .to eq('https://name.atlassian.net/rest/agile/1.0/board/1')
      end
    end

    context 'when there is board id' do
      let!(:jira_project) do
        create(:jira_board,
               :with_board_id,
               product: product,
               jira_project_key: project_key)
      end
      it 'do nothing' do
        expect(subject).to be_falsey
      end
    end
  end
end
