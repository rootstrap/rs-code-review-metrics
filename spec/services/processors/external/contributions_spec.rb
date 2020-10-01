require 'rails_helper'

RSpec.describe Processors::External::Contributions do
  let!(:user) { create(:user, login: 'hvilloria') }
  context 'when there are repos for the given username' do
    let!(:pull_requests_events_payload) do
      create(:gitub_api_client_pull_requests_events_payload, actor: { login: user.login })
    end

    before do
      stub_get_pull_requests_events(user.login, pull_requests_events_payload)
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
      stub_get_pull_requests_events(user.login)
    end

    it 'does not save any project' do
      expect { described_class.call }.not_to change { ExternalPullRequest.count }
    end

    it 'does not save any pull request' do
      expect { described_class.call }.not_to change { ExternalPullRequest.count }
    end
  end
end
