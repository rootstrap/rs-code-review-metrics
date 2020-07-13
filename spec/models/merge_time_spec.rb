require 'rails_helper'

RSpec.describe MergeTime, type: :model do
  subject { build :merge_time }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without value' do
      subject.value = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:pull_request_id) }
    it { is_expected.to belong_to(:pull_request) }
  end
end
