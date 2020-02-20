require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  describe 'events' do
    context 'pull request' do
      let!(:payload) { (create :pull_request_payload_with_repository) }
      let!(:event) { 'pull_request' }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }

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

        it 'sets status to removed' do
          change_action_to('review_request_removed')
          subject
          expect(ReviewRequest.where(status: 'removed').count).to eq(1)
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
      let(:payload) { (create :review_payload).merge((create :repository_payload)) }
      let(:event) { 'review' }
      let!(:review) { create :review, github_id: payload['review']['id'] }

      it 'sets body' do
        change_action_to('submitted')
        expect {
          subject
        }.to change { review.reload.body }.from(nil).to(payload['review']['body'])
      end

      it 'edits body' do
        change_action_to('edited')
        body = payload['review']['body']
        review.update!(body: body)

        expect {
          subject
        }.to change { review.reload.body }.from(body).to(payload['changes']['body'])
      end

      it 'sets status to removed' do
        change_action_to('dismissed')
        expect {
          subject
        }.to change { review.reload.status }.from('active').to('removed')
      end
    end

    context 'review comment' do
      let(:payload) do
        (create :review_comment_payload)
          .merge((create :repository_payload))
          .merge((create :pull_request_payload))
      end
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:event) { 'review_comment' }
      let(:review_comment) { create :review_comment, github_id: payload['comment']['id'] }

      it 'sets body' do
        change_action_to('created')
        expect {
          subject
        }.to change { review_comment.reload.body }.from(nil).to(payload['comment']['body'])
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
        }.to change { review_comment.reload.status }.from('active').to('removed')
      end
    end
  end
end
