require 'rails_helper'

RSpec.describe CodeOwnersService do
  describe '.call' do
    before { create(:project) }
    context 'when project content from the github repo api was not found or is empty' do
      it 'does not save associate any code owner to project' do
        allow_any_instance_of(GithubReposApi).to receive(:get_content_of_file)
          .and_return({})
        expect_any_instance_of(CodeOwnersService)
          .not_to receive(:save_code_owners_from_file)
        described_class.call
      end
    end

    let(:string_from_file) do
      "# These owners will be the default owners for everything in
       # the repo. Unless a later match takes precedence,
       # @global-owner1 and @global-owner2 will be requested for
       # review when someone opens a pull request.

       * @hdamico @santiagovidal @santib @horacio @hvilloria"
    end

    context 'when project content from the github repo api is present' do
      before do
        create(:user, login: 'hdamico')
        create(:user, login: 'santiagovidal')
        create(:user, login: 'santib')
        create(:user, login: 'horacio')
        create(:user, login: 'hvilloria')
      end

      it 'associates code owner per user in the file' do
        allow_any_instance_of(GithubReposApi).to receive(:get_content_of_file) { string_from_file }
        described_class.call
        expect(Project.first.code_owners.size).to eq(5)
      end
    end
  end
end
