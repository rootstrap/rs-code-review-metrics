require 'rails_helper'

describe Builders::Repository do
  describe '.call' do
    let(:repository_payload) { create(:repository_payload) }
    subject { described_class.call(repository_payload) }

    context 'when the repository has not been created' do
      it 'creates only one' do
        expect { subject }.to change(Repository, :count).by(1)
      end

      it 'creates it' do
        subject

        created_repository = Repository.find_by(github_id: repository_payload['id'])
        expect(created_repository.name).to eq repository_payload['name']
        expect(created_repository.description).to eq repository_payload['description']
        expect(created_repository.is_private).to eq repository_payload['private']
      end
    end

    context 'when the repository has already been created' do
      let!(:repository) do
        create(
          :repository,
          github_id: repository_payload['id'],
          name: repository_payload['name'],
          description: repository_payload['description'],
          is_private: repository_payload['private']
        )
      end

      it 'does not create a new repository' do
        expect { subject }.not_to change(Repository, :count)
      end

      it 'just returns it' do
        expect(subject).to eq repository
      end
    end

    context 'when the repository is marked as deleted' do
      let!(:repository) { create(:repository, github_id: repository_payload['id']) }

      before { repository.destroy }

      it 'does not create a new repository' do
        expect { subject }.not_to change(Repository.with_deleted, :count)
      end

      it 'returns it and restores it' do
        expect(subject).to eq(repository)
        expect(subject.deleted?).to eq(false)
      end
    end

    describe 'archived property' do
      context 'when the repository is archived' do
        let(:repository_payload) { create(:repository_payload, archived: true) }

        it 'the repository is assigned the "ignored" relevance' do
          subject

          repository = Repository.find_by(github_id: repository_payload['id'])
          expect(repository.relevance).to eq Repository.relevances[:ignored]
        end
      end

      context 'when the repository is not archived' do
        let(:repository_payload) { create(:repository_payload, archived: false) }

        it 'the repository is not assigned a relevance' do
          subject

          repository = Repository.find_by(github_id: repository_payload['id'])
          expect(repository.relevance).to eq Repository.relevances[:unassigned]
        end
      end
    end
  end
end
