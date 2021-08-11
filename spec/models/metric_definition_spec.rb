# == Schema Information
#
# Table name: metric_definitions
#
#  id          :bigint           not null, primary key
#  code        :enum             not null
#  explanation :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe MetricDefinition, type: :model do
  subject { build(:metric_definition) }

  context 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(subject).to be_valid
      end

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:explanation) }
    end
  end

  context 'with invalid attributes' do
    it 'is not valid without name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end
end
