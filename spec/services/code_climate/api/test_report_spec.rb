require 'rails_helper'

RSpec.describe CodeClimate::Api::TestReport do
  describe '#coverage' do
    let(:coverage) { 99.0 }
    let(:code_climate_test_report_payload) do
      create(:code_climate_test_report_payload, coverage: coverage)
    end

    subject(:test_report) do
      CodeClimate::Api::TestReport.new(code_climate_test_report_payload['data'])
    end

    it 'returns the test coverage percentage of the report' do
      expect(test_report.coverage).to eq coverage
    end
  end
end
