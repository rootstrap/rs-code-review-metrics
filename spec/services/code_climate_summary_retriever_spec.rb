require 'rails_helper'

RSpec.describe CodeClimateSummaryRetriever do
  describe '.call' do
    let(:project) { create(:project) }

    before do
      create(:code_climate_project_metric, project_id: project.id)
    end

    it 'returns a code climate project instance' do
      expect(described_class.call(project.id)).to be_an_instance_of(CodeClimateProjectMetric)
    end
  end
end
