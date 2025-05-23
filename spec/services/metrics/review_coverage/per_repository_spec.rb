require 'rails_helper'

RSpec.describe Metrics::ReviewCoverage::PerRepository do
  describe '.call' do
    let(:subject) { described_class.call(repository.id) }
    let(:repository) { create(:repository) }
    let(:beginning_of_day) { Time.zone.today.beginning_of_day }
    let(:entity_type) { 'Repository' }
    let(:metric_name) { :review_coverage }

    context 'when there is available data' do
      before do
        pull_request1 = create(
          :pull_request,
          :merged,
          repository: repository,
          merged_at: beginning_of_day + 1.hour
        )
        pull_request2 = create(
          :pull_request,
          :merged,
          repository: repository,
          merged_at: beginning_of_day + 3.hours
        )
        pull_request1.review_coverage.update!(coverage_percentage: 80.0)
        pull_request2.review_coverage.update!(coverage_percentage: 90.0)
      end

      it 'returns the metric' do
        metrics = subject
        expect(metrics.count).to eq 1
      end

      it 'returns the average value' do
        metric = subject.first
        expect(metric.value).to eq 85.0
      end

      context 'when interval is set' do
        let(:interval) { 4.weeks.ago.beginning_of_week..Time.current.end_of_week }
        let(:subject) { described_class.call(repository.id, interval) }

        before do
          pull_request = create(
            :pull_request,
            :merged,
            repository: repository,
            merged_at: 5.weeks.ago
          )
          pull_request.review_coverage.update!(coverage_percentage: 85.0)
        end

        it 'does not change metric value' do
          metric = subject.first
          expect(metric.value).to eq 85.0
        end
      end
    end

    context 'when no data is available' do
      it 'returns no metrics' do
        expect(subject).to be_empty
      end
    end
  end
end
