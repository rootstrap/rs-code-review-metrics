# == Schema Information
#
# Table name: jira_sprints
#
#  id               :bigint           not null, primary key
#  active           :boolean
#  deleted_at       :datetime
#  ended_at         :datetime
#  name             :string
#  points_committed :integer
#  points_completed :integer
#  started_at       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jira_id          :integer          not null
#  jira_project_id  :bigint           not null
#
# Indexes
#
#  index_jira_sprints_on_jira_project_id  (jira_project_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_project_id => jira_projects.id)
#

require 'rails_helper'

describe JiraSprint, type: :model do
  subject { build :jira_sprint }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_presence_of(:jira_id) }
    it { is_expected.to validate_uniqueness_of(:jira_id) }

    it { is_expected.to belong_to(:jira_project) }
  end
end
