require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::ReviewTurnaround do
  describe '#records_with_departments' do
    let(:department) { Department.first }
    let(:project) { create(:project, language: department.languages.first) }
    let(:review_request) { create(:review_request, project: project) }

    before { create(:completed_review_turnaround, review_request: review_request) }

    it 'returns CompletedReviewTurnaround entities joined with Department' do
      expect(subject.records_with_departments.pluck(:department_id)).to be_present
    end
  end

  describe '#resolve_interval' do
    let(:completed_review_turnaround) do
      create(:completed_review_turnaround, value: value_in_seconds)
    end
    let(:value_in_seconds) { 54_000 }

    it 'returns the interval that matches the entity value in hours' do
      expect(subject.resolve_interval(completed_review_turnaround)).to eq('12-24')
    end
  end
end
