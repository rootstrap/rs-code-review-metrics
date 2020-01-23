require 'rails_helper'

describe GithubHandler do
  context 'handling github requests' do
    let(:raw_payload) do
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
      }
    end
    let(:payload) { JSON.parse(raw_payload.to_json, object_class: OpenStruct) }
    let(:github_handler) { GithubHandler.new('pull_request', raw_payload, 'stub') }

    describe '#review_request' do
      let!(:pull_request) { create :pull_request, github_id: 1000 }

      it 'creates a review request' do
        expect { github_handler.review_request }.to change(ReviewRequest, :count).by(1)
      end

      it 'adds user to the DB' do
        expect {
          github_handler.create_or_find_user(payload.requested_reviewer)
        }.to change(User, :count).by(1)
      end

      context 'when user already exists' do
        let!(:user) do
          create(
            :user,
            github_id: 1001,
            login: 'pentacat',
            node_id: 'MDExOlB1bGxc5MTQ3NDM3'
          )
        end

        it 'does not duplicate same user with different login' do
          expect {
            github_handler.create_or_find_user(payload.requested_reviewer)
          }.to change(User, :count).by(0)
        end
      end
    end

    describe '#closed' do
      let!(:pull_request) { create :pull_request, github_id: 1000 }

      it 'sets status closed' do
        expect { github_handler.closed }.to change { pull_request.reload.closed? }.from(false).to(true)
      end
    end

    describe '#opened' do
      it 'adds pr to the DB' do
        expect { github_handler.opened }.to change(PullRequest, :count).by(1)
      end

      context 'when duplicated pr' do
        let!(:pr) do
          create(
            :pull_request,
            github_id: 1000,
            number: 4,
            node_id: 'MDExOlB1bGxSZXF1ZXN0Mjc5MTQ3NDM3',
            title: 'Renamed Pull req'
          )
        end

        it 'raises an exception' do
          expect { github_handler.opened }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    describe '#review_removal' do
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

      it 'sets status to removed' do
        expect { github_handler.review_removal }.to change { review_request.reload.removed? }.from(false).to(true)
      end
    end
  end
end
