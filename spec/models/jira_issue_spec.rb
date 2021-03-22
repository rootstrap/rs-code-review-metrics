# == Schema Information
#
# Table name: jira_issues
#
#  id              :bigint           not null, primary key
#  environment     :enum
#  informed_at     :datetime         not null
#  issue_type      :enum             not null
#  key             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  jira_project_id :bigint           not null
#
# Indexes
#
#  index_jira_issues_on_jira_project_id  (jira_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_project_id => jira_projects.id)
#

require 'rails_helper'

RSpec.describe JiraIssue, type: :model do
  subject { build :jira_issue }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_presence_of(:informed_at) }
    it { is_expected.to validate_presence_of(:issue_type) }
    it { is_expected.to belong_to(:jira_project) }
    it { is_expected.to validate_inclusion_of(:issue_type).in_array(JiraIssue.issue_types.keys) }
    it { is_expected.to validate_inclusion_of(:environment).in_array(JiraIssue.environments.keys) }
  end

  describe 'bugs' do
    let!(:epic_issue) { create(:jira_issue, issue_type: 'epic') }
    let!(:bug_issue) { create(:jira_issue, issue_type: 'bug') }

    it 'returns the issues with a bug type' do
      expect(JiraIssue.bugs).to contain_exactly(bug_issue)
    end
  end
end
