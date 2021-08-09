require 'rails_helper'

describe Builders::ReviewOrCommentTurnaround do
  describe '#build_review_turnaround' do
    let(:pull_request)    { create(:pull_request) }
    let(:santib)          { create(:user, login: 'santib') }
    let(:hernan)          { create(:user, login: 'hdamico') }
    let(:rr)              { create(:review_request, reviewer: santib, pull_request: pull_request) }
    let(:second_rr)       { create(:review_request, reviewer: hernan, pull_request: pull_request) }

    shared_context 'and is the only action for the review request' do
      it 'creates a review turnaround' do
        expect { action }.to change { ReviewTurnaround.count }.by(1)
      end

      it 'creates a review turnaround with the correct values' do
        action
        review_turnaround = ReviewTurnaround.last
        expect(review_turnaround[:value]).to eq(0)
        expect(review_turnaround[:review_request_id]).to eq(rr.id)
      end
    end

    shared_context 'and is not the only action for the review request' do
      context 'because there is one review' do
        let!(:second) { create :review, review_request: rr }

        it 'does not create review turnaround' do
          expect { action }.to_not change { ReviewTurnaround.count }
        end
      end

      context 'because there is a comment' do
        let!(:second) { create :pull_request_comment, review_request: rr }

        it 'does not create review turnaround' do
          expect { action }.to_not change { ReviewTurnaround.count }
        end
      end
    end

    context 'when a review is created' do
      let(:action) { create :review, review_request: rr }

      include_context 'and is the only action for the review request'
      include_context 'and is not the only action for the review request'
    end

    context 'when a comment is created' do
      let(:action) { create :pull_request_comment, review_request: rr }

      include_context 'and is the only action for the review request'
      include_context 'and is not the only action for the review request'
    end
  end

  describe '#build_second_review_turnaround' do
    let(:project) { create(:project, language: Language.first) }
    let(:vita)    { create(:user, login: 'santiagovidal') }
    let(:santib)  { create(:user, login: 'santib') }
    let(:hernan)  { create(:user, login: 'hdamico') }
    let(:pr)      { create(:pull_request, owner: vita, project: project) }

    let(:rr) do
      create(:review_request, owner: vita, reviewer: santib, project: project, pull_request: pr)
    end

    let(:second_rr) do
      create(:review_request, owner: vita, reviewer: hernan, project: project, pull_request: pr)
    end

    shared_context 'when a different user make the second review' do
      let(:second_action) do
        create(:review,
               owner: hernan, pull_request: pr, review_request: second_rr)
      end

      it_behaves_like 'when a different user make the second action'
    end

    shared_context 'when a different user make the second comment' do
      let(:second_action) do
        create(:pull_request_comment,
               owner: hernan, pull_request: pr, review_request: second_rr)
      end

      it_behaves_like 'when a different user make the second action'
    end

    shared_context 'when the owner of the second action makes a third review' do
      let(:third_action) do
        create(:review,
               owner: hernan, pull_request: pr, review_request: second_rr)
      end

      it_behaves_like 'when the owner of the second action makes a third action'
    end

    shared_context 'when the owner of the second action makes a third comment' do
      let(:third_action) do
        create(:pull_request_comment,
               owner: hernan, pull_request: pr, review_request: second_rr)
      end

      it_behaves_like 'when the owner of the second action makes a third action'
    end

    shared_examples 'when a different user make the second action' do
      it 'builds the complete review turnaround' do
        expect { second_action }.to change { CompletedReviewTurnaround.count }.by(1)
      end
    end

    shared_examples 'when the owner of the second action makes a third action' do
      before { second_action }

      it 'does not build the completed review turnaround' do
        expect { third_action }.not_to change { CompletedReviewTurnaround.count }
      end
    end

    context 'when there is a review and a different user make the second action' do
      let!(:review) do
        create(:review, owner: santib, pull_request: pr, review_request: rr)
      end

      include_context 'when a different user make the second review'
      include_context 'when a different user make the second comment'

      include_context 'when the owner of the second action makes a third review'
      include_context 'when the owner of the second action makes a third comment'
    end

    context 'when there is a comment and a different user make the second action' do
      let!(:comment) do
        create(:pull_request_comment,
               owner: santib,
               pull_request: pr,
               review_request: rr)
      end

      include_context 'when a different user make the second review'
      include_context 'when a different user make the second comment'

      include_context 'when the owner of the second action makes a third review'
      include_context 'when the owner of the second action makes a third comment'
    end
  end
end
