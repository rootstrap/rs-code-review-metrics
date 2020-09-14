require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::PullRequestSize do
  describe '#retrieve_records' do
    let(:time_range) { Time.zone.today.beginning_of_week..Time.zone.today.end_of_week }
    let(:old_timestamp) { time_range.first.yesterday }
    let(:backend_department) { Department.find_by(name: 'backend') }
    let(:frontend_department) { Department.find_by(name: 'frontend') }

    let(:backend_project) { create(:project, language: backend_department.languages.first) }
    let(:frontend_project) { create(:project, language: frontend_department.languages.first) }

    let(:frontend_pr) do
      create(:pull_request, project: frontend_project, opened_at: Time.zone.now)
    end
    let(:last_week_backend_pr) do
      create(:pull_request, project: backend_project, opened_at: old_timestamp)
    end
    let(:this_week_backend_pr) do
      create(:pull_request, project: backend_project, opened_at: Time.zone.now)
    end

    let!(:frontend_pr_size) do
      create(:pull_request_size, pull_request: frontend_pr)
    end
    let!(:last_week_backend_pr_size) do
      create(:pull_request_size, pull_request: last_week_backend_pr)
    end
    let!(:this_week_backend_pr_size) do
      create(:pull_request_size, pull_request: this_week_backend_pr)
    end

    subject(:records_retrieved) do
      described_class.new.retrieve_records(
        entity_id: backend_department.id,
        time_range: time_range
      )
    end

    it 'returns only records with the requested department and in the requested time range' do
      expect(records_retrieved).to contain_exactly(this_week_backend_pr_size)
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
