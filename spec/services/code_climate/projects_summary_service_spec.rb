require 'rails_helper'

describe CodeClimate::ProjectsSummaryService do
  describe '.call' do
    let(:department) { create(:department) }
    let(:language) { create(:language, name: 'react_native', department_id: department.id) }
    let(:project) { create(:project, language_id: language.id) }
    let!(:code_climate_project) { create(:code_climate_project_metric, project_id: project.id) }
    let(:technologies) { ['react_native'] }
    it 'xxx' do
      described_class.call(department: department, from: nil, technologies: technologies)
    end
  end
end
