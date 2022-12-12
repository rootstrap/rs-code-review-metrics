require 'rails_helper'

RSpec.describe Builders::CompletedReviewTurnaround do
  describe '.call' do
    let(:repository) { create(:repository, language: Language.first) }
    let(:vita) { create(:user, login: 'santiagovidal') }
    let(:santib) { create(:user, login: 'santib') }
    let(:pr) { create(:pull_request, owner: vita, repository: repository) }

    let(:rr) do
      create(:review_request,
             owner: vita,
             reviewer: santib,
             repository: repository,
             pull_request: pr)
    end

    let(:correct_value) do
      weekend_in_seconds = WeekendSecondsInterval.call(start_date: review.opened_at, end_date: pr.opened_at)
      (review.opened_at.to_i - pr.opened_at.to_i) - weekend_in_seconds
    end

    shared_examples 'the corresponding completed review turnaround is created' do
      it 'returns the correct class' do
        expect(described_class.call(review)).to be_an(CompletedReviewTurnaround)
      end

      it 'returns the correct value in seconds' do
        expect(described_class.call(review).value).to eq(correct_value)
      end
    end

    context 'when second review is a review' do
      let!(:review) do
        create(:review, owner: santib, repository: repository, pull_request: pr, review_request: rr)
      end

      it_behaves_like 'the corresponding completed review turnaround is created'
    end

    context 'when second review is a comment' do
      let!(:review) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: rr)
      end

      it_behaves_like 'the corresponding completed review turnaround is created'
    end
  end
end
