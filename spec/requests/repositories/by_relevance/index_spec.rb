require 'rails_helper'

RSpec.describe 'Repositories::ByRelevanceController' do
  let(:ruby_repository_1) do
    create(:repository, relevance: 'internal', language: Language.find_by(name: 'ruby'))
  end
  let(:ruby_repository_2) do
    create(:repository, relevance: 'commercial', language: Language.find_by(name: 'ruby'))
  end
  let(:node_repository_1) do
    create(:repository, relevance: 'internal', language: Language.find_by(name: 'nodejs'))
  end
  let(:node_repository_2) do
    create(:repository, relevance: 'commercial', language: Language.find_by(name: 'nodejs'))
  end
  let(:python_repository_1) do
    create(:repository, relevance: 'internal', language: Language.find_by(name: 'python'))
  end
  let(:python_repository_2) do
    create(:repository, relevance: 'commercial', language: Language.find_by(name: 'python'))
  end
  let(:subject) do
    get department_repositories_by_relevance_index_path(department_name: 'backend'), params: params
  end

  context 'when lang param is not present' do
    let(:params) do
      {
        metric: {
          period: 4
        }
      }
    end

    before do
      subject
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end

    it 'returns pull requests variable with data' do
      expect(assigns(:repositories)).not_to be_empty
    end
  end
end
