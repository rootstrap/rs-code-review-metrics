# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  name       :enum             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_departments_on_name  (name)
#

require 'rails_helper'

RSpec.describe Department, type: :model do
  subject { Department.first }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to have_many(:languages) }
    it { is_expected.to have_many(:metrics) }
  end
end
