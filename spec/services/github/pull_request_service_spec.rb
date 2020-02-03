require 'rails_helper'

describe Events::PullRequestService do
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
      },
      event: 'pull_request'
    }
  end
  let(:payload) { JSON.parse(raw_payload.to_json, object_class: OpenStruct) }
  let(:github_service) { described_class.call(raw_payload) }

  after { expect(Event.count).to eq(1) }

  describe '#review_request' do
    let!(:pull_request) { create :pull_request, github_id: 1000 }

    it 'creates a review request' do
      expect {
        github_service.review_requested
      }.to change(ReviewRequest, :count).by(1).and change(User, :count).by(2)
    end
  end

  describe '#closed' do
    let!(:pull_request) { create :pull_request, github_id: 1000 }

    it 'sets status closed' do
      expect {
        github_service.closed
      }.to change { pull_request.reload.closed? }.from(false).to(true)
    end
  end

  describe '#opened' do
    it 'adds pr and event to the DB' do
      expect {
        github_service.opened
      }.to change(Events::PullRequest, :count).by(1)
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
      expect {
        github_service.review_request_removed
      }.to change { review_request.reload.removed? }.from(false).to(true)
    end
  end
end
