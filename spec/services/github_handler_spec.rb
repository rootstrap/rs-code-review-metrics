require 'rails_helper'

describe GithubHandler do
  context 'handling review request' do
    let(:payload) do
      {
        action: 'review_requested',
        pull_request: {
          id: 1000,
          number: 2,
          state: 'open',
          node_id: 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3',
          title: 'Pull Request 2',
          locked: false,
          merged: false,
          draft: false,
          user: {
            node_id: 'MDQ6NlcjE4',
            login: 'heptacat',
            id: 1006
          }
        },
        requested_reviewer: {
          node_id: 'MDExOlB1bGxc5MTQ3NDM3',
          login: 'octocat',
          id: 1001
        }
      }.with_indifferent_access
    end
    let(:github_handler) { GithubHandler.new('pull_request', payload.to_json, 'stub') }

    describe 'users not existing' do
      it 'adds user to the DB' do
        expect {
          github_handler.create_or_find_user(payload['requested_reviewer'])
        }.to change(User, :count).by(1)
      end
    end

    describe 'one user existing' do
      let(:user) do
        create(
          :user,
          github_id: 1001,
          login: 'pentacat',
          node_id: 'MDExOlB1bGxc5MTQ3NDM3'
        )
      end

      it 'does not duplicate same user with different login' do
        user
        expect {
          github_handler.create_or_find_user(payload['requested_reviewer'])
        }.to change(User, :count).by(0)
      end
    end

    describe 'pull request not existing' do
      it 'adds pr to the DB' do
        expect {
          github_handler.create_or_find_pr(payload['pull_request'])
        }.to change(PullRequest, :count).by(1)
      end
    end

    describe 'pull request existing' do
      let(:pr) do
        create(
          :pull_request,
          github_id: 1000,
          number: 4,
          node_id: 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3',
          title: 'Renamed Pull req'
        )
      end

      it 'does not duplicate existing pr, even if data has changed' do
        pr
        expect {
          github_handler.create_or_find_pr(payload['pull_request'])
        }.to change(PullRequest, :count).by(0)
      end
    end

    describe 'review removal request' do
      let!(:pull_request) { create :pull_request, github_id: 1000 }
      let!(:user) do
        create :user,
          github_id: 1001,
          login: 'pentacat',
          node_id: 'MDExOlB1bGxc5MTQ3NDM3'
      end
      let!(:review_request) do
        create :review_request,
          pull_request: pull_request,
          owner: user,
          reviewer: user
      end

      before do
        github_handler.handle_review_removal
        review_request.reload
      end

      it 'sets status to removed' do
        expect(review_request.removed?).to be true
      end
    end
  end
end
