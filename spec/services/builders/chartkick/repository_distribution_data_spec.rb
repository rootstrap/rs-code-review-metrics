require 'rails_helper'

RSpec.describe Builders::Chartkick::RepositoryDistributionData do
  describe '.call' do
    context 'for a given entity' do
      let(:range) do
        Time.zone.today.beginning_of_week..Time.zone.today.end_of_week
      end

      let(:department) { Department.first }
      let(:repository) { create(:repository, language: department.languages.first) }
      let(:entity_id) { repository.id }
      let(:values_in_seconds) { [108_00, 900_00, 144_000, 198_000, 226_800, 270_000] }
      let(:values_for_average) { [100_000, 200_000] }

      let(:query) do
        { value_timestamp: range, name: metric_name }
      end

      subject do
        described_class.call(entity_id, query)
      end

      context 'when name is merge time' do
        let(:metric_name) { :merge_time }
        let(:one_hour_in_seconds) { 3600 }
        let(:average_value) { ((values_for_average.sum / 2).to_f / one_hour_in_seconds).round(1) }

        it_behaves_like 'merge time data distribution'
        it_behaves_like 'success rate'
        it_behaves_like 'average'
      end

      context 'when name is review turnaround' do
        let(:metric_name) { :review_turnaround }

        it_behaves_like 'review turnaround data distribution'
        it_behaves_like 'success rate'
      end

      context 'when name is pull request size' do
        let(:metric_name) { :pull_request_size }
        let(:average_value) { (values_for_average.sum / 2).round(1) }

        it_behaves_like 'pull request size data distribution'
        it_behaves_like 'average'
      end
    end
  end
end
