require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::PullRequestSize do
  describe '#records_with_departments' do
    let(:department) { Department.first }
    let(:project) { create(:project, language: department.languages.first) }
    let(:pull_request) { create(:pull_request, project: project) }

    before { create(:pull_request_size, pull_request: pull_request) }

    it 'returns PullRequestSize entities joined with Department' do
      expect(subject.records_with_departments.pluck(:department_id)).to be_present
    end
  end

  describe '#resolve_interval' do
    let(:pull_request_size) do
      create(:pull_request_size, value: value)
    end
    let(:value) { 317 }

    it 'returns the interval that matches the entity value' do
      expect(subject.resolve_interval(pull_request_size)).to eq('300-399')
    end
  end
end
