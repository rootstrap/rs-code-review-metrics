require 'rails_helper'

RSpec.describe Builders::Project do
  describe '.call' do
    let(:repository_payload) { create(:repository_payload)['repository'] }

    context 'when the project has not been created' do
      it 'creates only one' do
        expect { described_class.call(repository_payload) }.to change(Project, :count).by(1)
      end

      it 'creates it' do
        described_class.call(repository_payload)

        created_project = Project.find_by(github_id: repository_payload['id'])
        expect(created_project.name).to eq repository_payload['name']
        expect(created_project.description).to eq repository_payload['description']
        expect(created_project.is_private).to eq repository_payload['private']
      end
    end

    context 'when the project has already been created' do
      let!(:project) do
        create(
          :project,
          github_id: repository_payload['id'],
          name: repository_payload['name'],
          description: repository_payload['description'],
          is_private: repository_payload['private']
        )
      end

      it 'does not create a new project' do
        expect { described_class.call(repository_payload) }.not_to change(Project, :count)
      end

      it 'just returns it' do
        expect(described_class.call(repository_payload)).to eq project
      end
    end
  end
end
