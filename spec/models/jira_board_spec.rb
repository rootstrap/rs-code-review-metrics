# == Schema Information
#
# Table name: jira_boards
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  jira_project_key :string           not null
#  project_name     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#
# Indexes
#
#  index_jira_boards_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe JiraBoard, type: :model do
  subject { build :jira_board }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_uniqueness_of(:jira_project_key) }

    it { is_expected.to have_many(:jira_issues) }
    it { is_expected.to belong_to(:product) }

    context 'when jira project is empty' do
      it 'is valid' do
        subject.jira_project_key = ''
        expect(subject).to be_valid
      end
    end
  end
end
