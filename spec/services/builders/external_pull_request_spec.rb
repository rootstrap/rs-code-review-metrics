require 'rails_helper'

RSpec.describe Builders::ExternalPullRequest do
  let(:project) { create(:external_project) }
  let(:user) { create(:user) }
  context 'when there is already a pull request' do
    let!(:pull_request) { create(:external_pull_request) }

    let(:pull_request_data) do
      {
        id: pull_request.github_id,
        html_url: pull_request.html_url,
        body: pull_request.body,
        title: pull_request.title,
        user: { login: user.login }
      }
    end

    it 'returns that pull request' do
      expect(described_class.call(pull_request_data, project).id)
        .to eq(pull_request.id)
    end

    it 'does not create a new external pull request' do
      expect { described_class.call(pull_request_data, project) }
        .not_to change { ExternalPullRequest.count }
    end
  end

  context 'when there is no pull request created with a given id' do
    let(:pull_request_data) do
      {
        id: 132_158_840,
        html_url: 'https://github.com/Codertocat/Hello-World/pull/2',
        body: 'open source pull request',
        title: 'open source pull request title',
        user: { login: user.login }
      }
    end

    subject { described_class.call(pull_request_data, project) }

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
      expect(subject.owner.login).to eq(pull_request_data[:user][:login])
    end
  end
end
