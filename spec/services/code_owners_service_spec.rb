require 'rails_helper'

RSpec.describe CodeOwnersService do
  describe '.call' do
    let!(:project) { create(:project) }
    context 'when project content from the github repo api' do
      context 'was not found or is empty' do
        it 'does not save associate any code owner to project' do
          allow_any_instance_of(GithubReposApi).to receive(:get_content_from_file)
            .and_return({})
          expect_any_instance_of(CodeOwnersService)
            .not_to receive(:build_code_owners_array)
          described_class.call
        end
      end

      context 'is present' do
        let(:rs_metrics_code_owners) do
          '* @hdamico @santiagovidal @santib @horacio @hvilloria'
        end

        let!(:hosward_code_owner) { create(:user, login: 'hvilloria') }
        let!(:sandro_code_owner) { create(:user, login: 'sandro') }

        before do
          create(:user, login: 'hdamico')
          create(:user, login: 'santiagovidal')
          create(:user, login: 'santib')
          create(:user, login: 'horacio')
        end

        it 'associates code owner per user in the file' do
          allow_any_instance_of(GithubReposApi)
            .to receive(:get_content_from_file) { rs_metrics_code_owners }
          described_class.call
          expect(project.code_owners.size).to eq(5)
        end

        context 'and has new code owners' do
          let(:updated_code_owners_file) do
            '* @hdamico @santiagovidal @santib @horacio @sandro'
          end

          it 'adds code_owners that are not in the file' do
            allow_any_instance_of(GithubReposApi)
              .to receive(:get_content_from_file) { updated_code_owners_file }
            described_class.call
            expect(project.code_owners.include?(hosward_code_owner)).to be(false)
          end

          it 'adds code_owners that are in the file' do
            allow_any_instance_of(GithubReposApi)
              .to receive(:get_content_from_file) { updated_code_owners_file }
            described_class.call
            expect(project.code_owners.include?(sandro_code_owner)).to be(true)
          end
        end
      end
    end
  end
end
