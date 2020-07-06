require 'rails_helper'

RSpec.describe ReviewTurnaround, type: :model do
  subject { build :review_turnaround }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without value' do
      subject.value = nil
      expect(subject).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:review_request_id) }
    it { is_expected.to belong_to(:review_request) }
  end
end
