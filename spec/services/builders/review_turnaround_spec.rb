require 'rails_helper'

RSpec.describe Builders::ReviewTurnaround do
  describe '.call' do
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
