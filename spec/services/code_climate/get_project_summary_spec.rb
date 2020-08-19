require 'rails_helper'

describe CodeClimate::GetProjectSummary do
  describe '#repository' do
    subject(:repository) { described_class.send(:new, project: project).send(:repository) }

    let(:project) { create(:project) }
    let(:code_climate_repository_json) { create(:code_climate_repository_payload) }

    context 'when the project does not have a code climate project metric' do
      before do
        on_request_repository_by_slug(
          project_name: project.name,
          respond: { status: 200, body: code_climate_repository_json }
        )
      end

      it 'gets the repository by slug' do
        expect(repository).to be_a(CodeClimate::Api::Repository)
      end
    end

    context 'when the project has a code climate project metric' do
      context 'but not a repository id' do
        before do
          create(:code_climate_project_metric, cc_repository_id: nil, project: project)

          on_request_repository_by_slug(
            project_name: project.name,
            respond: { status: 200, body: code_climate_repository_json }
          )
        end

        it 'gets the repository by slug' do
          expect(repository).to be_a(CodeClimate::Api::Repository)
        end
      end

      context 'and a repository id' do
        before do
          code_climate_project_metric = create(:code_climate_project_metric, project: project)

          on_request_repository_by_repo_id(
            repo_id: code_climate_project_metric.cc_repository_id,
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
