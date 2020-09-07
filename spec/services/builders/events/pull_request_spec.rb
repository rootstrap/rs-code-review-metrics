require 'rails_helper'

RSpec.describe Builders::Events::PullRequest do
  describe '.call' do
    let(:payload) { create(:full_pull_request_payload) }
    let(:pull_request_payload) { payload['pull_request'] }
    let(:repository_payload) { payload['repository'] }
    let(:user_payload) { pull_request_payload['user'] }

    before { stub_pull_request_files_with_payload(payload) }

    context 'when the pull request has not been created before' do
      it 'creates a new one' do
        expect { described_class.call(payload: payload) }
          .to change { Events::PullRequest.count }
          .by(1)
      end

      it 'assigns the correct attributes to it' do
        built_pull_request = described_class.call(payload: payload)
        expect(built_pull_request.number).to eq(pull_request_payload['number'])
        expect(built_pull_request.state).to eq(pull_request_payload['state'])
        expect(built_pull_request.node_id).to eq(pull_request_payload['node_id'])
        expect(built_pull_request.title).to eq(pull_request_payload['title'])
        expect(built_pull_request.locked).to eq(boolean_of(pull_request_payload['locked']))
        expect(built_pull_request.draft).to eq(boolean_of(pull_request_payload['draft']))
        expect(built_pull_request.html_url).to eq(pull_request_payload['html_url'])
        expect(built_pull_request.opened_at).to eq(pull_request_payload['created_at'])
      end

      it 'creates or assigns the correct references to it' do
        built_pull_request = described_class.call(payload: payload)
        expect(built_pull_request.project.github_id).to eq(repository_payload['id'])
        expect(built_pull_request.owner.github_id).to eq(user_payload['id'])
        expect(built_pull_request.owner.projects).to include(built_pull_request.project)
        expect(built_pull_request.pull_request_size).to be_present
      end
    end

    context 'when the pull request has been created before' do
      let!(:pull_request) { create(:pull_request, github_id: pull_request_payload['id']) }

      it 'returns it' do
        expect(described_class.call(payload: payload)).to eq pull_request
      end

      it 'does not create a new one' do
        expect { described_class.call(payload: payload) }
          .not_to change { Events::PullRequest.count }
      end
    end
  end

  def boolean_of(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
