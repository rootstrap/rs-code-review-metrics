require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::ReviewTurnaround do
  describe '#retrieve_records' do
    let(:time_range) { Time.zone.today.beginning_of_week..Time.zone.today.end_of_week }
    let(:old_timestamp) { time_range.first.yesterday }
    let(:backend_department) { Department.find_by(name: 'backend') }
    let(:frontend_department) { Department.find_by(name: 'frontend') }

    let(:backend_project) { create(:project, language: backend_department.languages.first) }
    let(:frontend_project) { create(:project, language: frontend_department.languages.first) }

    let(:frontend_rr) do
      create(:review_request, project: frontend_project)
    end
    let(:last_week_backend_rr) do
      create(:review_request, project: backend_project)
    end
    let(:this_week_backend_rr) do
      create(:review_request, project: backend_project)
    end

    let!(:frontend_review_turnaround) do
      create(:completed_review_turnaround, review_request: frontend_rr)
    end
    let!(:last_week_backend_review_turnaround) do
      create(
        :completed_review_turnaround,
        review_request: last_week_backend_rr,
        created_at: old_timestamp
      )
    end
    let!(:this_week_backend_review_turnaround) do
      create(:completed_review_turnaround, review_request: this_week_backend_rr)
    end

    subject(:records_retrieved) do
      described_class.new.retrieve_records(
        entity_id: backend_department.id,
        time_range: time_range
      )
    end

    it 'returns only records with the requested department and in the requested timeframe' do
      expect(records_retrieved).to contain_exactly(this_week_backend_review_turnaround)
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
