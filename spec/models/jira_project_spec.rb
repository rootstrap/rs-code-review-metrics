# == Schema Information
#
# Table name: jira_projects
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  jira_project_key :string           not null
#  jira_self_url    :string
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  jira_board_id    :integer
#  product_id       :bigint
#
# Indexes
#
#  index_jira_projects_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
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
    it { is_expected.to validate_uniqueness_of(:jira_board_id).allow_blank }

    it { is_expected.to have_many(:jira_issues) }
    it { is_expected.to have_many(:jira_sprints) }
    it { is_expected.to belong_to(:product) }
  end
end
