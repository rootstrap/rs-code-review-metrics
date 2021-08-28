require 'rails_helper'

describe Processors::JiraProjectPlannedToDoneUpdater do
  describe '#call' do
    let(:product) { create(:product) }
    let(:project_key) { 'TES' }
    let!(:jira_board_id) { 1 }
    let!(:jira_project) do
      create(:jira_board,
             :with_board_id,
             product: product,
             jira_project_key: project_key,
             jira_board_id: jira_board_id)
    end
    let(:subject) { described_class.call(jira_project) }
    let(:first_sprint) { JiraSprint.first }
    let(:last_sprint) { JiraSprint.last }
    let(:sprints) do
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
    let(:report) do
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

    before do
      stub_get_sprints_ok(payload_sprints, jira_board_id)
      stub_get_sprint_report_ok(payload_report, jira_board_id, 1)
      stub_get_sprint_report_ok(payload_report, jira_board_id, 2)
    end

    context 'when there are no sprints associated in the project yet' do
      it 'creates the records on the db' do
        expect { subject }.to change { JiraSprint.count }.from(0).to(2)
      end

      it 'is associated to the project' do
        subject
        expect(last_sprint.jira_board).to eq(jira_project)
      end

      it 'is set the started at date' do
        subject
        expect(last_sprint.started_at).to eq('2021-08-11T18:38:11.123Z')
      end

      it 'is set the ended at date' do
        subject
        expect(last_sprint.ended_at).to eq('2021-08-25T18:38:08.000Z')
      end

      it 'is set the status' do
        subject
        expect(last_sprint.active).to be true
      end

      it 'is set the name' do
        subject
        expect(last_sprint.name).to eq('TES Sprint 2')
      end

      it 'is set the committed points' do
        subject
        expect(last_sprint.points_committed).to eq(20)
      end

      it 'is set the completed points' do
        subject
        expect(last_sprint.points_completed).to eq(15)
      end
    end

    context 'when the sprint is closed' do
      it 'is set the status' do
        subject
        expect(first_sprint.active).to be false
      end
    end

    context 'when there are sprints returned previously' do
      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraSprint.count }
      end
    end

    context 'when there are no sprints to report' do
      let(:sprints) { [] }
      let(:report) { [] }

      it 'does not create a new record for them' do
        subject

        expect { subject }.not_to change { JiraSprint.count }
      end
    end
  end
end
