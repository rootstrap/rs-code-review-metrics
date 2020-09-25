require 'rails_helper'

RSpec.describe GithubClient::PullRequest do
  describe '#get' do
    let(:pull_request_payload) { create(:github_api_client_pull_request_payload) }
    let(:repository_payload) { pull_request_payload['base']['repo'] }
    let(:pull_request) do
      create(
        :external_pull_request,
        number: pull_request_payload['number'],
        external_project: project
      )
    end
    let(:project) { create(:external_project, full_name: repository_payload['full_name']) }

    subject(:client) { described_class.new(pull_request) }

    before { stub_get_pull_request(pull_request, pull_request_payload) }

    it 'returns the pull request info from Github' do
      expect(client.get).to eq pull_request_payload
    end
  end

  describe '#files' do
    let(:project) { create(:project) }
    let(:pull_request) { create(:pull_request, project: project) }
    let(:pull_request_file_payload) { create(:pull_request_file_payload) }

    subject(:client) { described_class.new(pull_request) }

    before { stub_pull_request_files_with_pr(pull_request, [pull_request_file_payload]) }

    it 'returns the pull request changes files' do
      expect(client.files).to contain_exactly(pull_request_file_payload)
    end

    context 'when there is more than one page of results' do
      let(:pull_request_file_payload_2) { create(:pull_request_file_payload) }
      let(:pull_request_files_payloads) do
        [pull_request_file_payload, pull_request_file_payload_2]
      end

      before do
        stub_pull_request_files_with_pr(
          pull_request,
          pull_request_files_payloads,
          results_per_page: 1
        )
      end

      it 'returns the pull request files from all pages' do
        expect(client.files).to match_array(pull_request_files_payloads)
      end
    end
  end
end
