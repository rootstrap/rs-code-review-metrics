require 'rails_helper'

describe CodeClimate::ProjectsSummaryService do
  describe '.call' do
    let(:department) { Department.mobile.take }
    let(:language) { create(:language, name: 'react_native', department_id: department.id) }
    let(:project) { create(:project, language_id: language.id) }
    let(:technologies) { ['react_native'] }
    let!(:first_code_climate_project) do
      create(:code_climate_project_metric, project_id: project.id)
    end
    let!(:second_code_climate_project) do
      create(:code_climate_project_metric, project_id: project.id)
    end
    let(:code_climate_metrics) { CodeClimateProjectMetric.all }

    subject { described_class.call(department: department, from: nil, technologies: technologies) }

    let(:invalid_issues_count_average) do
      code_climate_metrics.map(&:invalid_issues_count).sum / code_climate_metrics.size
    end

    let(:wont_fix_issues_count_average) do
      code_climate_metrics.map(&:wont_fix_issues_count).sum / code_climate_metrics.size
    end

    let(:open_issues_count_average) do
      code_climate_metrics.map(&:open_issues_count).sum / code_climate_metrics.size
    end

    let(:ratings) do
      code_climate_metrics.each_with_object(Hash.new(0)) do |code_climate_metric, ratings|
        ratings[code_climate_metric.code_climate_rate] += 1
      end
    end

    it 'instances a project summary to collect the code climate issues' do
      expect(CodeClimate::ProjectsSummary).to receive(:new)
      subject
    end

    it 'returns the correct invalid issues' do
      expect(subject.invalid_issues_count_average).to eq(invalid_issues_count_average)
    end

    it 'returns the correct wont fix issues' do
      expect(subject.wont_fix_issues_count_average).to eq(wont_fix_issues_count_average)
    end

    it 'returns the correct open issues average' do
      expect(subject.open_issues_count_average).to eq(open_issues_count_average)
    end

    it 'returns the correct ratings' do
      expect(subject.ratings).to eq(ratings)
    end
  end
end
