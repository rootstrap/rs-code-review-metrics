# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe JiraProject, type: :model do
  subject { build :jira_project }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_presence_of(:jira_project_key) }
    it { is_expected.to validate_uniqueness_of(:jira_project_key) }

    it { is_expected.to have_many(:jira_issues) }
  end
end
