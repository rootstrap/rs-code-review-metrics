require 'rails_helper'

describe JiraClient::Repository do
  let(:repository_key) { 'TES' }
  let!(:jira_board_id) { 1 }
  let(:jira_board) { create(:jira_board, jira_project_key: repository_key) }
  let(:payload) { { issues: bugs } }

  describe 'board' do
    let(:payload) { { values: board } }
    let(:board) do
      [
        {
          'id': 1,
          'self': 'https://name.atlassian.net/rest/agile/1.0/board/1',
          'name': 'TestEM (TES)',
          'type': 'scrum',
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
    subject { described_class.new(jira_board).board }

    before { stub_get_board_ok(payload, repository_key) }

    context 'when update board' do
      let!(:jira_board) do
        create(:jira_board,
               :no_board_id,
               jira_project_key: repository_key)
      end
      it 'returns an array with the data' do
        expect(subject).to match_array(board)
      end
    end
  end

  describe 'sprints' do
    let!(:jira_board) do
      create(:jira_board,
             jira_project_key: repository_key,
             jira_board_id: jira_board_id)
    end
    let!(:sprints) do
      [
        {
          'id': 1,
          'self': 'https://name.atlassian.net/rest/agile/1.0/sprint/1',
          'state': 'closed',
          'name': 'TES Sprint 1',
          'startDate': '2021-08-09T19:55:38.006Z',
          'endDate': '2021-08-23T19:55:33.000Z',
          'completeDate': '2021-08-11T18:36:50.088Z',
          'originBoardId': 1,
          'goal': ''
        },
        {
          'id': 2,
          'self': 'https://name.atlassian.net/rest/agile/1.0/sprint/2',
          'state': 'active',
          'name': 'TES Sprint 2',
          'startDate': '2021-08-11T18:38:11.123Z',
          'endDate': '2021-08-25T18:38:08.000Z',
          'originBoardId': 1,
          'goal': ''
        }
      ]
    end
    let!(:report) do
      {
        'completedIssues': [],
        'issuesNotCompletedInCurrentSprint': [],
        'puntedIssues': [],
        'issuesCompletedInAnotherSprint': [],
        'completedIssuesInitialEstimateSum': {
          'value': 15.0,
          'text': '15.0'
        },
        'completedIssuesEstimateSum': {
          'value': 15.0,
          'text': '15.0'
        },
        'issuesNotCompletedInitialEstimateSum': {
          'value': 2.0,
          'text': '2.0'
        },
        'issuesNotCompletedEstimateSum': {
          'value': 5.0,
          'text': '5.0'
        },
        'allIssuesEstimateSum': {
          'value': 22.0,
          'text': '22.0'
        },
        'puntedIssuesInitialEstimateSum': {
          'text': 'null'
        },
        'puntedIssuesEstimateSum': {
          'text': 'null'
        },
        'issuesCompletedInAnotherSprintInitialEstimateSum': {
          'text': 'null'
        },
        'issuesCompletedInAnotherSprintEstimateSum': {
          'text': 'null'
        },
        'issueKeysAddedDuringSprint': {
          'TS-6': true
        }
      }
    end
    let(:payload_sprints) { { values: sprints } }
    let(:payload_report)  { { contents: report } }

    subject { described_class.new(jira_board).sprints }

    before do
      stub_get_sprints_ok(payload_sprints, 1)
      stub_get_sprint_report_ok(payload_report, jira_board_id, 1)
      stub_get_sprint_report_ok(payload_report, jira_board_id, 2)
    end

    context 'when there is not any sprint on the board' do
      let(:sprints) { [] }

      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when there are sprints on the board' do
      it 'returns an array with the data' do
        sprints.each do |sprint|
          sprint.merge!(report: report.with_indifferent_access)
        end
        expect(subject).to match_array(sprints)
      end
    end
  end

  describe 'bugs' do
    subject { described_class.new(jira_board).bugs }

    before { stub_get_bugs_ok(payload, repository_key) }

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
      before { stub_failed_authentication(repository_key) }

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track)
          .with(JiraBoards::NoProjectKeyError.new(repository_key),
                custom_data: Faraday::ForbiddenError)

        subject
      end
    end
  end

  describe 'issues' do
    subject { described_class.new(jira_board).issues }

    before { stub_get_issues_ok(payload, repository_key) }

    context 'when there is not any issue on the account' do
      let(:bugs) { [] }

      it 'returns an empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when there are issues on the account' do
      let(:bugs) do
        [
          {
            "key": 'TES-4',
            "fields": {
              "customfield_10000": {
                "value": 'Production'
              },
              "created": '2021-03-14T15:48:04.000-0300',
              "resolutiondate": '2021-03-20T15:48:04.000-0300',
              "status": {
                "statusCategory": {
                  "key": 'done'
                }
              }
            }
          }
        ]
      end

      it 'returns an array with the data' do
        expect(subject).to match_array(bugs)
      end
    end

    context 'when the request fails for unauthorized user' do
      let(:bugs) { [] }

      before { stub_issues_failed_authentication(repository_key) }

      it 'notifies the error to exception hunter' do
        expect(ExceptionHunter).to receive(:track)
          .with(JiraBoards::NoProjectKeyError.new(repository_key),
                custom_data: Faraday::ForbiddenError)

        subject
      end
    end
  end
end
