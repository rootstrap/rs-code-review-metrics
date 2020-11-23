require 'rails_helper'

RSpec.describe 'By Relevance' do
  let(:ruby_project_1) do
    create(:project, relevance: 'internal', language: Language.find_by(name: 'ruby'))
  end
  let(:ruby_project_2) do
    create(:project, relevance: 'commercial', language: Language.find_by(name: 'ruby'))
  end
  let(:node_project_1) do
    create(:project, relevance: 'internal', language: Language.find_by(name: 'nodejs'))
  end
  let(:node_project_2) do
    create(:project, relevance: 'commercial', language: Language.find_by(name: 'nodejs'))
  end
  let(:python_project_1) do
    create(:project, relevance: 'internal', language: Language.find_by(name: 'python'))
  end
  let(:python_project_2) do
    create(:project, relevance: 'commercial', language: Language.find_by(name: 'python'))
  end
  let(:subject) do
    get department_projects_by_relevance_index_path(department_name: 'backend'), params: params
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
      expect(assigns(:projects)).not_to be_empty
    end
  end
end
