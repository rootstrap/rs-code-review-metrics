require 'rails_helper'

RSpec.describe Builders::CompletedReviewTurnaround do
  describe '.call' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }
    let(:santib) { create(:user, login: 'santib') }
    let(:pr) { create(:pull_request, owner: vita, project: project) }

    let(:rr) do
      create(:review_request, owner: vita, reviewer: santib, project: project, pull_request: pr)
    end

    let(:correct_value) do
      review.opened_at.to_i - pr.opened_at.to_i
    end

    shared_examples 'returns' do
      it 'the completed review turnaround created' do
        expect(described_class.call(review)).to be_an(CompletedReviewTurnaround)
      end

      it 'the correct value for the review in seconds' do
        expect(described_class.call(review).value).to eq(correct_value)
      end
    end

    context 'when second review is a review' do
      let!(:review) do
        create(:review, owner: santib, project: project, pull_request: pr, review_request: rr)
      end

      it_behaves_like 'returns'
    end

    context 'when second review is a comment' do
      let!(:review) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: rr)
      end

      it_behaves_like 'returns'
    end
  end
end
