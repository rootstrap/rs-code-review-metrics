require 'rails_helper'

RSpec.describe JiraClient::Repository do
  let(:project_key) { 'TES' }
  let(:jira_project) { create(:jira_project, jira_project_key: project_key) }

  subject { described_class.new(jira_project).bugs }

  describe 'bugs' do
    before { stub_get_bugs_ok(payload, project_key) }

    let(:payload) { { issues: bugs } }
    let(:bugs) { [] }

    context 'when there is not any bug on the account' do
      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when there are bugs on the account' do
      let(:bugs) do
        [
          {
            "key": 'TES-4',
            "fields": {
              "customfield_10000": {
                "value": 'Production'
              },
              "created": '2021-03-14T15:48:04.000-0300'
            }
          }
        ]
      end

      it 'returns an array with the data' do
        expect(subject).to match_array(bugs)
      end
    end

    context 'when the request fails for unauthorized user' do
      before { stub_failed_authentication(project_key) }

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track).with(Faraday::ForbiddenError)

        subject
      end
    end
  end
end
