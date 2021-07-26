require 'rails_helper'

RSpec.describe GithubService do
  subject { described_class.call(payload: payload, event: event) }

  describe 'events' do
    context 'pull request' do
      let!(:payload) { (create :full_pull_request_payload, action: action, merged: merged) }
      let(:action) { 'open' }
      let(:merged) { false }
      let!(:event) { 'pull_request' }
      let(:project) { create(:project, github_id: payload['repository']['id']) }
      let(:pr_size) { 10 }
      let(:pull_request) do
        create :pull_request,
               project: project,
               github_id: payload['pull_request']['id'],
               number: payload['pull_request']['number'],
               size: pr_size
      end
      let(:review_request) { create :review_request }

      before { stub_pull_request_files_with_payload(payload) }

      it 'creates a pull request' do
        expect { subject }.to change(Events::PullRequest, :count).by(1)
      end

      context 'when the action is open' do
        let(:action) { 'open' }

        before { pull_request.closed! }

        it 'sets state to open' do
          expect { subject }.to change { pull_request.reload.open? }.from(false).to(true)
        end
      end

      context 'when the action is closed' do
        let(:action) { 'closed' }

        it 'sets state closed' do
          expect {
            subject
          }.to change { pull_request.reload.closed? }.from(false).to(true)
        end

        context 'and the pull request is merged' do
          let(:merged) { true }

          it 'sets state merged' do
            expect { subject }.to change { pull_request.reload.merged_at }.from(nil).to(Time)
          end
        end

        context 'and the pull request is not merged' do
          let(:merged) { false }

          it 'blanks the size value from the pull request' do
            expect { subject }.to change { pull_request.reload.size }.from(pr_size).to(nil)
          end
        end
      end

      describe 'when the action is review_request_removed' do
        let(:action) { 'review_request_removed' }

        describe 'with an exiting review_request' do
          let!(:reviewer) do
            create :user, github_id: payload['requested_reviewer']['id']
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

          it 'sets state to removed' do
            subject
            expect(ReviewRequest.where(state: 'removed').count).to eq(1)
          end
        end

        describe 'with a missing review_request because the requested reviewer is a team' do
          before do
            payload['requested_team'] = payload.delete('requested_reviewer')
          end

          it 'raises an error' do
            expect {
              subject
            }.to raise_error(PullRequests::RequestTeamAsReviewerError,
                             'Teams review requests are not supported.')
          end
        end
      end

      context 'when the action is review requested' do
        before { change_action_to('review_requested') }

        it 'creates a review request' do
          expect {
            subject
          }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
        end

        it 'raises an error when a team is requested as reviewer' do
          payload['requested_team'] = payload.delete('requested_reviewer')

          expect {
            subject
          }.to raise_error(PullRequests::RequestTeamAsReviewerError,
                           'Teams review requests are not supported.')
        end
      end

      context 'when the action is edited' do
        context 'and the base branch changed' do
          let(:payload) { (create :full_pull_request_payload, :edited_base) }

          it 'updates the pull request size value' do
            expect { subject }.to change { pull_request.reload.size }
          end
        end

        context 'and the base branch did not change' do
          let(:payload) { (create :full_pull_request_payload, :edited) }

          it 'does not update the pull request size value' do
            expect { subject }.not_to change { pull_request.reload.size }
          end
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

        it 'raise an exception if there is no review request' do
          review_request.update!(reviewer: (create :user))
          expect {
            subject
          }.to raise_error(Reviews::NoReviewRequestError)
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

    context 'push' do
      let(:payload) { create(:push_payload, branch: branch) }
      let(:event) { 'push' }
      let(:branch) { 'newest_cool_feature' }

      it 'creates a push' do
        expect { subject }.to change(Events::Push, :count).by(1)
      end

      context 'when it has a matching pull request' do
        let!(:pull_request) { create(:pull_request, project: project, branch: branch) }
        let(:project) { create(:project, github_id: repository_payload['id']) }
        let(:repository_payload) { payload['repository'] }
        let(:pull_request_file_payload) { create(:pull_request_file_payload) }
        let(:additions) { pull_request_file_payload['additions'] }

        before { stub_pull_request_files_with_pr(pull_request, [pull_request_file_payload]) }

        it 'creates or updates the pull request size metric' do
          subject
          expect(pull_request.reload.size).to eq(additions)
        end
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

    context 'pull_request_comment' do
      let(:payload) do
        create :pull_request_comment_payload,
               body: 'initial body contents',
               changes: { body: 'new body contents' }
      end
      let(:event) { 'pull_request_comment' }
      let(:pull_request_comment) do
        create :pull_request_comment, github_id: payload['comment']['id'], state: 'created'
      end
      let!(:user) { create :user, github_id: payload['comment']['user']['id'] }
      let!(:project) do
        create :project, github_id: payload['repository']['id']
      end
      let!(:pull_request) do
        create :pull_request, number: payload['issue']['number'], project_id: project.id
      end
      let!(:review_request) do
        create :review_request,
               pull_request_id: pull_request.id,
               reviewer_id: user.id
      end

      it 'creates a pull request comment event' do
        expect { subject }.to change(Events::PullRequestComment, :count).by(1)
      end

      context 'when the action is created' do
        it 'sets body' do
          change_action_to('created')
          expect {
            subject
          }.to change { pull_request_comment.reload.body }
            .from(pull_request_comment.body)
            .to(payload['comment']['body'])
        end
      end

      context 'when the action is edited' do
        it 'edits body' do
          change_action_to('edited')
          body = payload['comment']['body']
          pull_request_comment.update!(body: body)

          expect {
            subject
          }.to change { pull_request_comment.reload.body }
            .from(body).to('new body contents')
        end

        it 'sets edited' do
          change_action_to('edited')
          expect {
            subject
          }.to change { pull_request_comment.reload.state }
            .from(pull_request_comment.state).to('edited')
        end
      end

      context 'when the action is deleted' do
        it 'sets deleted' do
          change_action_to('deleted')
          expect {
            subject
          }.to change { pull_request_comment.reload.state }
            .from(pull_request_comment.state).to('deleted')
        end
      end

      it 'raise an exception if there is no review request' do
        review_request.update!(reviewer: (create :user))
        expect {
          subject
        }.to raise_error(Reviews::NoReviewRequestError)
      end
    end
  end
end
