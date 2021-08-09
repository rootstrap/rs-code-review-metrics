require 'rails_helper'

describe Builders::Chartkick::DevelopmentMetrics do
  describe Builders::Chartkick::DevelopmentMetrics::Product do
    let(:product) { create(:product) }
    let(:period) { 4 }
    let(:defect_escape_rate_entities) { %i[per_defect_escape_rate per_defect_escape_values] }

    describe '.call' do
      it 'returns a hash with the right data per entity for each metric' do
        metric_data = described_class.call(product.id, period)
        expect(metric_data[:defect_escape_rate].keys).to match_array(defect_escape_rate_entities)
      end
    end
  end

  describe Builders::Chartkick::DevelopmentMetrics::Product do
    let(:product) { create(:product) }
    let(:project_key) { 'TES' }
    let!(:jira_project) { create(:jira_project, product: product) }
    let(:period) { 4 }
    let(:defect_escape_rate_entities) { %i[per_defect_escape_rate per_defect_escape_values] }
    let(:development_cycle_entities) do
      %i[per_development_cycle_average per_development_cycle_values]
    end

    describe '.call' do
      it 'returns a hash with the right data per entity for defect escape rate metric' do
        metric_data = described_class.call(product.id, period)
        expect(metric_data[:defect_escape_rate].keys).to match_array(defect_escape_rate_entities)
      end

      it 'returns a hash with the right data per entity for development cycle metric' do
        metric_data = described_class.call(product.id, period)
        expect(metric_data[:development_cycle].keys).to match_array(development_cycle_entities)
      end
    end
  end

  describe Builders::Chartkick::DevelopmentMetrics::Project do
    let(:product) { create(:product) }
    let(:project) { create(:project, product: product) }
    let(:period) { 4 }
    let(:review_turnaround_entities) { %i[per_project per_users_project per_project_distribution] }
    let(:merge_time_entities) { %i[per_project per_users_project per_project_distribution] }

    describe '.call' do
      it 'returns a hash with the right data per entity for each metric' do
        metric_data = described_class.call(project.id, period)
        expect(metric_data[:review_turnaround].keys).to match_array(review_turnaround_entities)
        expect(metric_data[:merge_time].keys).to match_array(merge_time_entities)
      end
    end
  end

  describe Builders::Chartkick::DevelopmentMetrics::Department do
    let(:department) { Department.first }
    let(:period) { 4 }
    let(:review_turnaround_entities) do
      %i[per_department per_language per_department_distribution]
    end
    let(:merge_time_entities) do
      %i[per_department per_language per_department_distribution]
    end
    let(:pr_size_entities) { :per_department_distribution }

    describe '.call' do
      it 'returns a hash with the right data per entity for each metric' do
        metric_data = described_class.call(department.id, period)
        expect(metric_data[:review_turnaround].keys).to match_array(review_turnaround_entities)
        expect(metric_data[:merge_time].keys).to match_array(merge_time_entities)
        expect(metric_data[:pull_request_size].keys).to match_array(pr_size_entities)
      end
    end
  end
end
