# == Schema Information
#
# Table name: reviews
#
#  id                :bigint           not null, primary key
#  body              :string
#  opened_at         :datetime         not null
#  state             :enum             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  github_id         :integer
#  owner_id          :bigint
#  project_id        :bigint
#  pull_request_id   :bigint           not null
#  review_request_id :bigint
#
# Indexes
#
#  index_reviews_on_owner_id           (owner_id)
#  index_reviews_on_project_id         (project_id)
#  index_reviews_on_pull_request_id    (pull_request_id)
#  index_reviews_on_review_request_id  (review_request_id)
#  index_reviews_on_state              (state)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#

require 'rails_helper'

RSpec.describe Events::Review, type: :model do
  describe 'validations' do
    subject { build :review }

    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:review_request) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without github id' do
      subject = build :review, github_id: nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without opened_at' do
      subject = build :review, opened_at: nil
      expect(subject).to_not be_valid
    end
  end

  describe 'callbacks' do
    context 'when a review is created' do
      before { travel_to(Time.zone.today.beginning_of_day) }
      let(:review_request) { create(:review_request) }
      let(:review) { create :review, review_request: review_request }
    
      it 'creates a review turnaround with the correct values' do
        review
        review_turnaround = ReviewTurnaround.last
        expect(review_turnaround[:value]).to eq(0)
        expect(review_turnaround[:review_request_id]).to eq(review_request.id)
      end

      it 'creates a review turnaround' do
        expect { review }.to change { ReviewTurnaround.count }.from(0).to(1)
      end

      context 'when there is more than one review in a review request' do
        let!(:second_review) { create :review, review_request: review_request }

        it 'does not create review turnaround' do
          expect { review }.to_not change { ReviewTurnaround.count }
        end
      end
    end
  end
end
