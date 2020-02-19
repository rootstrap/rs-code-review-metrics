require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  describe 'events' do
    context 'pull request' do
      let!(:payload) { (create :pull_request_payload).merge((create :repository_payload)) }
      let!(:event) { 'pull_request' }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }

      it 'sets state to open' do
        payload.merge!('action' => 'open')
        pull_request.closed!

        expect { subject }.to change { pull_request.reload.open? }.from(false).to(true)
      end

      it 'sets state closed' do
        payload.merge!('action' => 'closed')

        expect {
          subject
        }.to change { pull_request.reload.closed? }.from(false).to(true)
      end

      it 'sets state merged' do
        payload.merge!('action' => 'closed')
        payload['pull_request']['merged'] = true

        expect { subject }.to change { pull_request.reload.merged_at }.from(nil).to(Time)
      end

      describe '#review_request_removed' do
        before { payload.merge!('action' => 'review_request_removed') }
        let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
        let!(:reviewer) { create :user, github_id: payload['requested_reviewer']['id'] }
        let!(:review_request) { create :review_request, reviewer: reviewer, pull_request: pull_request }

        it 'sets status to removed' do
          subject
          expect(ReviewRequest.where(status: 'removed').count).to eq(1)
        end
      end

      describe '#review_request' do
        before { payload.merge!('action' => 'review_requested') }

        it 'creates a review request' do
          expect {
            subject
          }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
        end
      end
    end

    context 'review' do
      let(:payload) { (create :review_payload).merge((create :repository_payload)) }
      let(:event) { 'review' }
      let!(:review) { create :review, github_id: payload['review']['id'] }

      it 'sets body' do
        payload.merge!('action' => 'submitted')

        expect {
          subject
        }.to change { review.reload.body }.from(nil).to(payload['review']['body'])
      end

      it 'edits body' do
        payload.merge!('action' => 'edited')
        body = payload['review']['body']
        review.update!(body: body)

        expect {
          subject
        }.to change { review.reload.body }.from(body).to(payload['changes']['body'])
      end

      it 'sets status to removed' do
        payload.merge!('action' => 'dismissed')

        expect {
          subject
        }.to change { review.reload.status }.from('active').to('removed')
      end
    end

    context 'review comment' do
      let(:payload) { (create :review_comment_payload)
        .merge((create :repository_payload))
        .merge((create :pull_request_payload)) }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:event) { 'review_comment' }
      let(:review_comment) { create :review_comment, github_id: payload['comment']['id'] }

      it 'sets body' do
        payload.merge!('action' => 'created')

        expect {
          subject
        }.to change { review_comment.reload.body }.from(nil).to(payload['comment']['body'])
      end

      it 'edits body' do
        payload.merge!('action' => 'edited')
        body = payload['comment']['body']
        review_comment.update!(body: body)

        expect {
          subject
        }.to change { review_comment.reload.body }.from(body).to(payload['changes']['body'])
      end

      it 'sets removed' do
        payload.merge!('action' => 'deleted')

        expect {
          subject
        }.to change { review_comment.reload.status }.from('active').to('removed')
      end
    end
  end
end
