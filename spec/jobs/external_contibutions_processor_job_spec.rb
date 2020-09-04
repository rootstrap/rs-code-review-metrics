require 'rails_helper'

RSpec.describe ExternalContributionsProcessorJob do
  it 'executes external contributions processor' do
    expect(Processors::External::Contributions).to receive(:call)

    described_class.perform_now
  end

  context 'for a rootstrap member working on external repositories' do
    let(:user) { create(:user) }

    let!(:repositories_payloads) do
      create_list(:github_api_client_repositories_payload, 2).flatten
    end

    context 'with pull requests made for the first project' do
      let!(:pull_request_for_first_project) do
        create(:gitub_api_client_pull_requests_payload, user: { login: user.login })
      end

      before do
        stub_get_repos_from_user(user.login, repositories_payloads)
        stub_get_pull_requests(repositories_payloads.first['id'], pull_request_for_first_project)
        stub_get_pull_requests(repositories_payloads.second['id'])
      end

      it 'saves just the project with pull request associated' do
        described_class.perform_now
        expect(ExternalProject.last.github_id).to eq(repositories_payloads.first['id'])
      end

      it 'does not saves any project without pull requests' do
        described_class.perform_now
        expect(ExternalProject.pluck(:github_id)).not_to include(repositories_payloads.second['id'])
      end

      it 'creates a external project record' do
        expect { described_class.perform_now }.to change { ExternalProject.count }.by(1)
      end
    end

    context 'with non pull request made' do
      before do
        stub_get_repos_from_user(user.login, repositories_payloads)
        stub_get_pull_requests(repositories_payloads.first['id'])
        stub_get_pull_requests(repositories_payloads.second['id'])
      end

      let(:external_github_ids) { ExternalProject.pluck(:github_id) }

      it 'does not create any external project' do
        expect { described_class.perform_now }.not_to change { ExternalProject.count }
      end

      it 'does not saves any external project without pull requests' do
        described_class.perform_now
        expect(external_github_ids).not_to include(repositories_payloads.second['id'])
        expect(external_github_ids).not_to include(repositories_payloads.first['id'])
      end
    end
  end
end
