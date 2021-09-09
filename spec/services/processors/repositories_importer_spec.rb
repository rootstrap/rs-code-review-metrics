require 'rails_helper'

RSpec.describe Processors::RepositoriesImporter do
  describe '.call' do
    let(:repository_payload) { create(:repository_payload) }

    before { stub_organization_repositories([repository_payload]) }

    it 'successfully imports the repository' do
      described_class.call

      imported_repository = Repository.find_by(github_id: repository_payload['id'])
      expect(imported_repository.name).to eq repository_payload['name']
      expect(imported_repository.description).to eq repository_payload['description']
      expect(imported_repository.is_private).to eq repository_payload['private']
    end

    context 'when the repository is new' do
      it 'creates a new repository' do
        expect { described_class.call }.to change(Repository, :count).by 1
      end
    end

    context 'when the repository has already been imported' do
      let(:github_id) { repository_payload['id'] }

      before { create(:repository, github_id: github_id) }

      it 'does not create a new one' do
        expect { described_class.call }.not_to change(Repository, :count)
      end

      context 'when there is information to update' do
        let(:updated_name) { 'totally-new_name' }
        let(:repository_payload) { create(:repository_payload, name: updated_name) }

        it 'updates it' do
          expect { described_class.call }
            .to change { Repository.find_by(github_id: github_id).name }
            .to(updated_name)
        end
      end
    end
  end
end
