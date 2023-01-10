# == Schema Information
#
# Table name: review_turnarounds
#
#  id                :bigint           not null, primary key
#  value             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  pull_request_id   :bigint
#  review_request_id :bigint           not null
#
# Indexes
#
#  index_review_turnarounds_on_pull_request_id    (pull_request_id)
#  index_review_turnarounds_on_review_request_id  (review_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (pull_request_id => events_pull_requests.id)
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

    it { is_expected.to belong_to(:review_request) }

    context 'when review request id is already been taken' do
      let(:review_request) { create(:review_request, id: 100) }
      let!(:review_turnaround) { create(:review_turnaround, review_request: review_request) }

      it 'raise uniqueness exception' do
        subject.review_request_id = 100

        expect {
          subject.save!
        }.to raise_error(Reviews::ReviewRequestUniquenessError)
      end
    end
  end
end
