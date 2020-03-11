require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  describe 'events' do
    context 'pull request' do
      let!(:payload) { (create :full_pull_request_payload) }
      let!(:event) { 'pull_request' }
      let(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }

      it 'creates a pull request' do
        expect { subject }.to change(Events::PullRequest, :count).by(1)
      end

      it 'sets state to open' do
        change_action_to('open')
        pull_request.closed!
        expect { subject }.to change { pull_request.reload.open? }.from(false).to(true)
      end

      it 'sets state closed' do
        change_action_to('closed')
        expect {
          subject
        }.to change { pull_request.reload.closed? }.from(false).to(true)
      end

      it 'sets state merged' do
        change_action_to('closed')
        payload['pull_request']['merged'] = true

        expect { subject }.to change { pull_request.reload.merged_at }.from(nil).to(Time)
      end

      describe '#review_request_removed' do
        let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
        let!(:reviewer) { create :user, github_id: payload['requested_reviewer']['id'] }
        let!(:review_request) do
          create :review_request,
                 reviewer: reviewer,
                 pull_request: pull_request
        end

        it 'sets state to removed' do
          change_action_to('review_request_removed')
          subject
          expect(ReviewRequest.where(state: 'removed').count).to eq(1)
        end
      end

      it 'creates a review request' do
        change_action_to('review_requested')
        expect {
          subject
        }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
      end
    end

    context 'review' do
      let(:payload) { (create :full_review_payload) }
      let(:event) { 'review' }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:review) { create :review, github_id: payload['review']['id'] }

      it 'creates a review' do
        expect { subject }.to change(Events::Review, :count).by(1)
      end

      it 'sets body' do
        change_action_to('submitted')
        expect {
          subject
        }.to change { review.reload.state }.from(review.state).to(payload['review']['state'])
      end

      it 'edits body' do
        change_action_to('edited')
        body = payload['review']['body']
        review.update!(body: body)

        expect {
          subject
        }.to change { review.reload.body }.from(body).to(payload['changes']['body'])
      end

      it 'sets state to dismissed' do
        change_action_to('dismissed')
        expect {
          subject
        }.to change { review.reload.state }.from(review.state).to('dismissed')
      end
    end

    context 'review comment' do
      let(:payload) { create :full_review_comment_payload }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:event) { 'review_comment' }
      let(:review_comment) { create :review_comment, github_id: payload['comment']['id'] }

      it 'creates a review comment' do
        expect { subject }.to change(Events::ReviewComment, :count).by(1)
      end

      it 'sets body' do
        change_action_to('created')
        expect {
          subject
        }.to change { review_comment.reload.body }.from(review_comment.body)
                                                  .to(payload['comment']['body'])
      end

      it 'edits body' do
        change_action_to('edited')
        body = payload['comment']['body']
        review_comment.update!(body: body)

        expect {
          subject
        }.to change { review_comment.reload.body }.from(body).to(payload['changes']['body'])
      end

      it 'sets removed' do
        change_action_to('deleted')
        expect {
          subject
        }.to change { review_comment.reload.state }.from('active').to('removed')
      end
    end
  end
end
