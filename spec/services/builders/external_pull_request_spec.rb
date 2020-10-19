require 'rails_helper'

RSpec.describe Builders::ExternalPullRequest do
  let!(:user) { create(:user) }

  context 'when there is already a pull request' do
    let!(:pull_request) { create(:external_pull_request, state: 'open', owner: user) }

    let(:pull_request_data) do
      create(
        :github_api_client_pull_request_payload,
        pull_request: pull_request,
        merged: true
      ).deep_symbolize_keys
    end

    it 'returns that pull request' do
      expect(described_class.call(pull_request_data).id)
        .to eq(pull_request.id)
    end

    it 'does not create a new external pull request' do
      expect { described_class.call(pull_request_data) }
        .not_to change { ExternalPullRequest.count }
    end

    it 'updates pull requests state to merged' do
      expect { described_class.call(pull_request_data) }
        .to change { pull_request.reload.state }.from('open').to('merged')
    end
  end

  context 'when there is no pull request created with a given id' do
    let(:pull_request_data) do
      create(
        :github_api_client_pull_request_payload,
        username: user.login
      ).deep_symbolize_keys
    end

    subject { described_class.call(pull_request_data) }

    it 'returns a new external pull request created' do
      expect(subject.github_id).to eq(pull_request_data[:id])
    end

    it 'creates a new record' do
      expect { subject }.to change { ExternalPullRequest.count }.by(1)
    end

    it 'creates all attributes correctly' do
      expect(subject.github_id).to eq(pull_request_data[:id])
      expect(subject.html_url).to eq(pull_request_data[:html_url])
      expect(subject.body).to eq(pull_request_data[:body])
      expect(subject.title).to eq(pull_request_data[:title])
      expect(subject.opened_at).to eq(pull_request_data[:created_at])
      expect(subject.owner.login).to eq(pull_request_data[:user][:login])
    end
  end
end
