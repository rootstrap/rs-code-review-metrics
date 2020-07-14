require 'rails_helper'

RSpec.describe CodeClimateSummaryRetriever do
  describe '.call' do
    let(:project) { create(:project) }
    before do
      create(:code_climate_project_metric, project_id: project.id)
    end
    it 'returns the code climate metrics for a given project' do
      expect(described_class.call(project.id).project_id).to eq(project.id)
    end
  end
end
