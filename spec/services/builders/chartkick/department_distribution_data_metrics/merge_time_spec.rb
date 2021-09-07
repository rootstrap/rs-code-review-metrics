require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::MergeTime do
  describe '#retrieve_records' do
    let(:time_range) { Time.zone.today.beginning_of_week..Time.zone.today.end_of_week }
    let(:old_timestamp) { time_range.first.yesterday }
    let(:backend_department) { Department.find_by(name: 'backend') }
    let(:frontend_department) { Department.find_by(name: 'frontend') }

    let(:backend_repository) { create(:repository, language: backend_department.languages.first) }
    let(:frontend_repository) { create(:repository, language: frontend_department.languages.first) }

    let(:frontend_pr) do
      create(:pull_request, repository: frontend_repository, merged_at: Time.zone.now)
    end
    let(:last_week_backend_pr) do
      create(:pull_request, repository: backend_repository, merged_at: old_timestamp)
    end
    let(:this_week_backend_pr) do
      create(:pull_request, repository: backend_repository, merged_at: Time.zone.now)
    end

    let!(:frontend_pr_merge_time) do
      create(:merge_time, pull_request: frontend_pr)
    end
    let!(:last_week_backend_pr_merge_time) do
      create(:merge_time, pull_request: last_week_backend_pr)
    end
    let!(:this_week_backend_pr_merge_time) do
      create(:merge_time, pull_request: this_week_backend_pr)
    end

    subject(:records_retrieved) do
      described_class.new.retrieve_records(
        entity_id: backend_department.id,
        time_range: time_range
      )
    end

    it 'returns only records with the requested department and in the requested time range' do
      expect(records_retrieved).to contain_exactly(this_week_backend_pr_merge_time)
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
