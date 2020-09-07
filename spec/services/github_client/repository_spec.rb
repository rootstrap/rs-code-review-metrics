require 'rails_helper'

RSpec.describe GithubClient::Repository do
  describe '#code_owners' do
    let(:project) { create(:project, name: 'rs-code-metrics') }

    context 'when the project or the file is not found' do
      before { stub_get_code_owners_not_found }
      it 'returns an empty string' do
        expect(described_class.new(project).code_owners)
          .to be_empty
      end
    end

    context 'when the project or the file is found' do
      before { stub_get_code_owners_file_ok }
      it 'returns a string with the codeowners as mentions' do
        expect(described_class.new(project).code_owners)
          .to include('@santiagovidal')
      end
    end
  end

  describe '#views' do
    let(:project) { create(:project) }
    let(:repository_views_payload) { create(:repository_views_payload) }

    context 'when the request succeeds' do
      before { stub_successful_repository_views(project, repository_views_payload) }

      it 'returns the views hash of that project on Github' do
        expect(described_class.new(project).views).to eq repository_views_payload
      end
    end

    context 'when the request fails' do
      before { stub_failed_repository_views(project) }

      it 'raises an exception' do
        expect { described_class.new(project).views }.to raise_error Faraday::ClientError
      end
    end
  end

  describe '#pull_requests' do
    let(:project) { build(:external_project) }
    subject { described_class.new(project) }

    context 'when repo does not have any pull request' do
      before do
        stub_get_pull_requests(project.github_id)
      end

      it 'returns an empty array' do
        expect(subject.pull_requests).to be_empty
      end
    end

    context 'when repo has pull request' do
      let!(:pull_requests_payload) do
        create(:gitub_api_client_pull_requests_payload)
      end

      before { stub_get_pull_requests(project.github_id, pull_requests_payload) }

      it 'returns an empty array' do
        expect(subject.pull_requests).not_to be_empty
      end
    end
  end
end
