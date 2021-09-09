require 'rails_helper'

RSpec.describe GithubClient::Repository do
  describe '#code_owners' do
    let(:repository) { create(:repository, name: 'rs-code-metrics') }

    context 'when the repository or the file is not found' do
      before { stub_get_code_owners_not_found }
      it 'returns an empty string' do
        expect(described_class.new(repository).code_owners)
          .to be_empty
      end
    end

    context 'when the repository or the file is found' do
      before { stub_get_code_owners_file_ok }
      it 'returns a string with the codeowners as mentions' do
        expect(described_class.new(repository).code_owners)
          .to include('@santiagovidal')
      end
    end
  end

  describe '#views' do
    let(:repository) { create(:repository) }
    let(:repository_views_payload) { create(:repository_views_payload) }

    context 'when the request succeeds' do
      before { stub_successful_repository_views(repository, repository_views_payload) }

      it 'returns the views hash of that repository on Github' do
        expect(described_class.new(repository).views).to eq repository_views_payload
      end
    end

    context 'when the request fails' do
      before { stub_failed_repository_views(repository) }

      it 'raises an exception' do
        expect { described_class.new(repository).views }.to raise_error Faraday::ClientError
      end
    end
  end

  describe '#pull_requests' do
    let(:repository) { build(:external_repository) }
    subject { described_class.new(repository) }

    context 'when repo does not have any pull request' do
      before do
        stub_get_pull_requests(repository.github_id)
      end

      it 'returns an empty array' do
        expect(subject.pull_requests).to be_empty
      end
    end

    context 'when repo has pull request' do
      let!(:pull_requests_payload) do
        [create(:github_api_client_pull_request_payload)]
      end

      before { stub_get_pull_requests(repository.github_id, pull_requests_payload) }

      it 'does not return an empty array' do
        expect(subject.pull_requests).not_to be_empty
      end
    end
  end
end
