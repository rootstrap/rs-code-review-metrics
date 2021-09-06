require 'rails_helper'

RSpec.describe Builders::MetricChart::OpenSource::LanguageVisits do
  describe '.call' do
    let(:language) { repository_1.language }
    let(:repository_1) { create(:repository, :open_source) }
    let(:repository_2) { create(:repository, :open_source, language: language) }
    let(:last_week_timestamp) { this_week_timestamp.last_week }
    let(:this_week_timestamp) { Time.zone.now.beginning_of_week }
    let!(:last_week_metric_1) { create_visits_metric(repository_1, 10, last_week_timestamp) }
    let!(:last_week_metric_2) { create_visits_metric(repository_2, 20, last_week_timestamp) }
    let!(:this_week_metric_1) { create_visits_metric(repository_1, 15, this_week_timestamp) }
    let!(:this_week_metric_2) { create_visits_metric(repository_2, 30, this_week_timestamp) }
    let(:last_week_visits) { last_week_metric_1.value + last_week_metric_2.value }
    let(:this_week_visits) { this_week_metric_1.value + this_week_metric_2.value }
    let(:language_visits_hash) do
      a_hash_including(
        name: language.name.titlecase,
        data: a_hash_including(
          last_week_timestamp.strftime('%Y-%m-%d') => last_week_visits,
          this_week_timestamp.strftime('%Y-%m-%d') => this_week_visits
        )
      )
    end

    it 'returns the weekly visits grouped by language' do
      expect(described_class.call.datasets).to include(language_visits_hash)
    end
  end

  def create_visits_metric(repository, value, timestamp)
    create(
      :metric,
      name: Metric.names[:open_source_visits],
      interval: Metric.intervals[:weekly],
      ownable: repository,
      value: value,
      value_timestamp: timestamp
    )
  end
end
