require 'rails_helper'

describe CodeClimate::GetRepositorySummary do
  describe '#repository' do
    subject(:repository) { described_class.send(:new, repository: repo).send(:find_repository) }

    let(:repo) { create(:repository) }
    let(:code_climate_repository_json) { create(:code_climate_repository_by_slug_payload) }

    context 'when the repository does not have a code climate repo metric' do
      before do
        on_request_repository_by_slug(
          repository_name: repo.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      it 'gets the repository by slug' do
        expect(repository).to be_a(CodeClimate::Api::Repository)
      end
    end

    context 'when the repository has a code climate repository metric' do
      context 'but not a repository id' do
        before do
          create(:code_climate_repository_metric, cc_repository_id: nil, repository: repo)

          on_request_repository_by_slug(
            repository_name: repo.name,
            respond: { status: 200, body: code_climate_repository_json }
          )
        end

        it 'gets the repository by slug' do
          expect(repository).to be_a(CodeClimate::Api::Repository)
        end
      end

      context 'and a repository id' do
        before do
          code_climate_repository_metric = create(:code_climate_repository_metric, repository: repo)

          on_request_repository_by_repo_id(
            repo_id: code_climate_repository_metric.cc_repository_id,
            respond: { status: 200, body: code_climate_repository_json }
          )
        end

        it 'gets the repository by repo id' do
          expect(repository).to be_a(CodeClimate::Api::Repository)
        end
      end
    end
  end
end
