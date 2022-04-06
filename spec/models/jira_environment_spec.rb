# == Schema Information
#
# Table name: jira_environments
#
#  id                 :bigint           not null, primary key
#  custom_environment :string
#  deleted_at         :datetime
#  environment        :enum             not null
#  jira_board_id      :bigint
#
# Indexes
#
#  index_jira_environments_on_jira_board_id  (jira_board_id)
#
# Foreign Keys
#
#  fk_rails_...  (jira_board_id => jira_boards.id)
#

require 'rails_helper'

RSpec.describe JiraEnvironment, type: :model do
  subject { build :jira_environment }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it { is_expected.to validate_presence_of(:custom_environment) }
    it { is_expected.to belong_to(:jira_board) }

    it do
      is_expected.to define_enum_for(:environment).with_values(JiraEnvironment.environments)
                                                  .backed_by_column_of_type(:enum)
    end

    describe 'standard environment' do
      let(:jira_development) { build(:jira_environment, :development) }
      let(:jira_qa) { build(:jira_environment, :qa) }
      let(:jira_staging) { build(:jira_environment, :staging) }
      let(:jira_production) { build(:jira_environment, :production) }

      it 'returns the correct environment' do
        expect(jira_development.environment).to eq('development')
        expect(jira_qa.environment).to eq('qa')
        expect(jira_staging.environment).to eq('staging')
        expect(jira_production.environment).to eq('production')
      end
    end
  end
end
