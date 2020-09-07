require 'rails_helper'

RSpec.describe Processors::External::Contributions do
  let!(:user) { create(:user, login: 'hvilloria') }
  context 'when there are repos for the given username' do
    let!(:repositories_payload) do
      create(:github_api_client_repositories_payload)
    end

    let!(:pull_requests_payload) do
      create(:gitub_api_client_pull_requests_payload, user: { login: user.login })
    end

    before do
      stub_get_repos_from_user(user.login, repositories_payload)
      stub_get_pull_requests(repositories_payload.first['id'], pull_requests_payload)
    end

    it 'saves the repository' do
      expect { described_class.call }.to change { ExternalProject.count }.by(1)
    end

    it 'saves the pull request for that user' do
      expect { described_class.call }.to change { ExternalPullRequest.count }.by(1)
    end
  end

  context 'when there are no repos for the given username' do
    before do
      stub_get_repos_from_user(user.login)
    end

    it 'does not save any project' do
      expect { described_class.call }.not_to change { ExternalPullRequest.count }
    end

    it 'does not save any pull request' do
      expect { described_class.call }.not_to change { ExternalPullRequest.count }
    end
  end
end
