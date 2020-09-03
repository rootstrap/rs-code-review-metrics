require 'rails_helper'

RSpec.describe Processors::External::PullRequests do
  let(:user) { create(:user, login: 'hvilloria') }

  let!(:repository_payload) do
    JSON.parse(
      create(:github_api_client_repositories_payload).first.to_json,
      symbolize_names: true
    )
  end

  context 'when user has pull request in a given project' do
    let!(:pull_requests_payload) do
      create(:gitub_api_client_pull_requests_payload, user: { login: user.login })
    end

    before do
      stub_get_pull_requests(repository_payload[:id], pull_requests_payload)
    end

    it 'saves given project' do
      expect { described_class.call(repository_payload, user.login) }
        .to change { ExternalProject.count }.by(1)
    end

    it 'saves pull requests where the username is owner' do
      expect { described_class.call(repository_payload, user.login) }
        .to change { ExternalPullRequest.count }.by(1)
    end
  end

  context 'when user doest not has pull request in a given project' do
    before do
      stub_get_pull_requests(repository_payload[:id])
    end

    it 'does not save given project' do
      expect { described_class.call(repository_payload, user.login) }
        .not_to change { ExternalProject.count }
    end

    it 'does not save the pull request' do
      expect { described_class.call(repository_payload, user.login) }
        .not_to change { ExternalPullRequest.count }
    end
  end
end
