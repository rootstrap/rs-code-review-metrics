# == Schema Information
#
# Table name: jira_issues
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
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
    it do
      is_expected.to define_enum_for(:environment).with_values(JiraIssue.environments)
                                                  .backed_by_column_of_type(:enum)
    end
    it do
      is_expected.to define_enum_for(:issue_type).with_values(JiraIssue.issue_types)
                                                 .backed_by_column_of_type(:enum)
    end
  end
end
