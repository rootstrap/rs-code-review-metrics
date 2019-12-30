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
        expect { github_handler.create_or_find_user(payload['requested_reviewer']) }.to change(User, :count).by(1)
      end
    end

    describe 'one user existing' do
      let(:user) { FactoryBot.create(:user, github_id: 1001, login: 'pentacat', node_id: 'MDExOlB1bGxc5MTQ3NDM3') }
      
      it 'does not duplicate same user with different login' do
        user
        expect { github_handler.create_or_find_user(payload['requested_reviewer']) }.to change(User, :count).by(0)
      end
    end
  end
end
