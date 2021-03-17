require 'rails_helper'

RSpec.describe 'Defect escape rate' do
  let(:jira_project_em) { create(:jira_project, project_name: 'Engineering Metrics', jira_project_key: 'EM') }

  let!(:bug_week_ago_prod) { create(:jira_issue, :bug, :production, jira_project: jira_project_em, informed_at: 1.week.ago) }
  let!(:bug_week_ago_staging) { create(:jira_issue, :bug, :staging, jira_project: jira_project_em, informed_at: 1.week.ago) }
  let!(:bug_week_ago_qa) { create(:jira_issue, :bug, :qa, jira_project: jira_project_em, informed_at: 1.week.ago) }
  let!(:bug_today_qa) { create(:jira_issue, :bug, :qa, jira_project: jira_project_em, informed_at: Date.today) }
  let!(:bug_today_prod) { create(:jira_issue, :bug, :production, jira_project: jira_project_em, informed_at: Date.today) }

  let(:subject) do
    get '/jira/defect_escape_rate', params: params
  end

  before do
    subject
  end

  context 'when metric params are provided' do
    let(:params) do
      {
        project_name: jira_project_em.project_name,
        from: 1.week.ago,
        to: Date.yesterday
      }
    end

    it 'returns a successful response' do
      expect(response).to be_ok
    end

    it 'returns the correspondent values' do
      expect(assigns(:bugs)).not_to be_empty
      expect(assigns(:escape_defect_rate)).to eq('66%')
      expect(assigns(:total_bugs)).to eq(3)
      expect(assigns(:user_environments_bugs)).to eq(2)
    end
  end
end
