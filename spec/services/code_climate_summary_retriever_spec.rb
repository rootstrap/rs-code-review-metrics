require 'rails_helper'

RSpec.describe CodeClimateSummaryRetriever do
  describe '.call' do
    let(:repository) { create(:repository) }

    before do
      create(:code_climate_project_metric, repository_id: repository.id)
    end

    it 'returns a code climate repository instance' do
      expect(described_class.call(repository.id)).to be_an_instance_of(CodeClimateProjectMetric)
    end
  end
end
