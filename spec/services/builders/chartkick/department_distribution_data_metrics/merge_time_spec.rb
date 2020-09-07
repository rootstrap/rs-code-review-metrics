require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::MergeTime do
  describe '#records_with_departments' do
    let(:department) { Department.first }
    let(:project) { create(:project, language: department.languages.first) }
    let(:pull_request) { create(:pull_request, project: project) }

    before { create(:merge_time, pull_request: pull_request) }

    it 'returns MergeTime entities joined with Department' do
      expect(subject.records_with_departments.pluck(:department_id)).to be_present
    end
  end

  describe '#resolve_interval' do
    let(:merge_time) do
      create(:merge_time, value: value_in_seconds)
    end
    let(:value_in_seconds) { 115_200 }

    it 'returns the interval that matches the entity value in hours' do
      expect(subject.resolve_interval(merge_time)).to eq('24-36')
    end
  end
end
