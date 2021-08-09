# == Schema Information
#
# Table name: products
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  description      :string
#  jira_project_key :string
#  name             :string           not null
#  created_at       :datetime
#  updated_at       :datetime
#
# Indexes
#
#  index_products_on_deleted_at  (deleted_at)
#  index_products_on_name        (name)
#

require 'rails_helper'

describe Product, type: :model do
  subject { build :product }

  context 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(subject).to be_valid
      end

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name) }
      it { is_expected.to validate_uniqueness_of(:jira_project_key) }
      it { is_expected.to have_many(:projects) }
      it { is_expected.to have_many(:metrics) }
      it { is_expected.to have_many(:jira_issues) }
    end

    context 'when jira project is empty' do
      it 'is valid' do
        subject.jira_project_key = ''
        expect(subject).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is not valid without name' do
        subject.name = nil
        expect(subject).to_not be_valid
      end
    end
  end
end
