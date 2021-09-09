require 'rails_helper'

RSpec.describe Builders::Chartkick::DepartmentDistributionDataMetrics::PullRequestSize do
  describe '#retrieve_records' do
    let(:time_range) { Time.zone.today.beginning_of_week..Time.zone.today.end_of_week }
    let(:old_timestamp) { time_range.first.yesterday }
    let(:backend_department) { Department.find_by(name: 'backend') }
    let(:frontend_department) { Department.find_by(name: 'frontend') }

    let(:backend_repository) { create(:repository, language: backend_department.languages.first) }
    let(:frontend_repository) { create(:repository, language: frontend_department.languages.first) }

    let!(:frontend_pr) do
      create(:pull_request, repository: frontend_repository, opened_at: Time.zone.now)
    end
    let!(:last_week_backend_pr) do
      create(:pull_request, repository: backend_repository, opened_at: old_timestamp)
    end
    let!(:this_week_backend_pr) do
      create(:pull_request, repository: backend_repository, opened_at: Time.zone.now)
    end
    let!(:null_size_pr) do
      create(:pull_request, repository: backend_repository, opened_at: Time.zone.now, size: nil)
    end

    subject(:records_retrieved) do
      described_class.new.retrieve_records(
        entity_id: backend_department.id,
        time_range: time_range
      )
    end

    it 'returns only records with the requested department and in the requested time range' do
      expect(records_retrieved).to contain_exactly(this_week_backend_pr)
    end

    it 'does not return pull request with null size value' do
      expect(records_retrieved).not_to include(null_size_pr)
    end
  end

  describe '#resolve_interval' do
    let(:pull_request) { create(:pull_request, size: 317) }

    it 'returns the interval that matches the entity value' do
      expect(subject.resolve_interval(pull_request)).to eq('300-399')
    end
  end
end
