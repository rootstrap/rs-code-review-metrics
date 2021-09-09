require 'rails_helper'

RSpec.describe CodeOwners::RepositoryHandler do
  describe '.call' do
    let!(:repository) { create(:repository, name: 'rs-code-metrics') }
    let!(:hosward_code_owner) { create(:user, login: 'hvilloria') }
    let!(:sandro_code_owner) { create(:user, login: 'sandro') }
    let(:updated_code_owners) do
      %w[hdamico santiagovidal santib horacio sandro]
    end

    before do
      create(:user, login: 'hdamico')
      create(:user, login: 'santiagovidal')
      create(:user, login: 'santib')
      create(:user, login: 'horacio')
    end

    context 'for a given repository and a list of code owners' do
      it 'associates code owner per user in the file' do
        described_class.call(repository, updated_code_owners)
        expect(repository.code_owners.size).to eq(5)
      end

      it 'removes code owners that are no longer in the file' do
        described_class.call(repository, updated_code_owners)
        expect(repository.code_owners.include?(hosward_code_owner)).to be(false)
      end

      it 'adds the new code owners' do
        described_class.call(repository, updated_code_owners)
        expect(repository.code_owners.include?(sandro_code_owner)).to be(true)
      end
    end
  end
end
