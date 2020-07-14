# == Schema Information
#
# Table name: review_turnarounds
#
#  id                :bigint           not null, primary key
#  value             :integer
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (review_request_id => review_requests.id)
#

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
