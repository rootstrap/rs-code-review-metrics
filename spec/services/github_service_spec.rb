require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  describe 'events' do
    context 'pull request' do
      let!(:payload) { (create :full_pull_request_payload) }
      let!(:event) { 'pull_request' }
      let(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:review_request) { create :review_request }

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
        let!(:reviewer) do
          create :user, github_id: payload['requested_reviewer']['id']
        end
        let!(:second_reviewer) do
          create :user
        end
        let!(:owner) do
          create :user, github_id: payload['pull_request']['user']['id']
        end
        let!(:review_request) do
          create :review_request,
                 owner: owner,
                 reviewer: reviewer,
                 pull_request: pull_request
        end

        before do
          create :review_request,
                 owner: owner,
                 reviewer: second_reviewer,
                 pull_request: pull_request
        end

        it 'sets state to removed' do
          change_action_to('review_request_removed')
          subject
          expect(ReviewRequest.where(state: 'removed').count).to eq(1)
        end
      end

      context 'when the action is review requested' do
        before { change_action_to('review_requested') }

        it 'creates a review request' do
          expect {
            subject
          }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
        end
      end
    end

    context 'review' do
      let(:payload) do
        create :review_payload,
               body: 'initial body contents',
               changes: { body: 'new body contents' }
      end
      let(:event) { 'review' }
      let(:review) { create :review, github_id: payload['review']['id'], state: 'approved' }
      let!(:user) { create :user, github_id: payload['review']['user']['id'] }
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let!(:review_request) do
        create :review_request,
               pull_request_id: pull_request.id,
               reviewer_id: user.id
      end

      context 'when submit a review' do
        before { change_action_to('submitted') }

        it 'creates a review' do
          expect { subject }.to change(Events::Review, :count).by(1)
        end

        it 'sets state to commented' do
          payload_state = payload['review']['state']
          expect {
            subject
          }.to change { review.reload.state }.from(review.state).to(payload_state)
        end
      end

      it 'edits body' do
        change_action_to('edited')
        payload['review']['edited_at'] = Time.zone.now.to_s
        body = payload['review']['body']
        review.update!(body: body)

        expect {
          subject
        }.to change { review.reload.body }.from(body).to('new body contents')
      end

      it 'sets state to dismissed' do
        change_action_to('dismissed')
        payload['review']['dismissed_at'] = Time.zone.now.to_s
        expect {
          subject
        }.to change { review.reload.state }.from(review.state).to('dismissed')
      end
    end

    context 'review comment' do
      let(:payload) do
        create :review_comment_payload,
               body: 'initial body contents',
               changes: { body: 'new body contents' }
      end
      let!(:pull_request) { create :pull_request, github_id: payload['pull_request']['id'] }
      let(:event) { 'review_comment' }
      let(:review_comment) { create :review_comment, github_id: payload['comment']['id'] }

      it 'creates a review comment' do
        expect { subject }.to change(Events::ReviewComment, :count).by(1)
      end

      context 'when the action is created' do
        let(:review_request) do
          create(:review_request, pull_request: review_comment.pull_request,
                                  reviewer: review_comment.owner)
        end

        it 'sets body' do
          change_action_to('created')
          expect {
            subject
          }.to change { review_comment.reload.body }.from(review_comment.body)
                                                    .to(payload['comment']['body'])
        end
      end

      it 'edits body' do
        change_action_to('edited')
        body = payload['comment']['body']
        review_comment.update!(body: body)

        expect {
          subject
        }.to change { review_comment.reload.body }.from(body).to('new body contents')
      end

      it 'sets removed' do
        change_action_to('deleted')
        expect {
          subject
        }.to change { review_comment.reload.state }.from('active').to('removed')
      end
    end

    context 'type not included in Event::TYPES' do
      let(:payload) { create :check_run_payload }
      let(:event) { 'check_run' }

      it 'saves the unhandled Event' do
        expect {
          suppress(Events::NotHandleableError) { subject }
        }.to change(Event, :count).by(1)
      end

      it 'raises an Events::NotHandleableError' do
        expect { subject }.to raise_error(Events::NotHandleableError)
      end
    end
  end
end
