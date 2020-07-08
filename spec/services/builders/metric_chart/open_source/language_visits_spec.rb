require 'rails_helper'

RSpec.describe Builders::MetricChart::OpenSource::LanguageVisits do
  describe '.call' do
    let(:language) { project.language }
    let(:project) { create(:project, :open_source) }
    let(:last_month_visit_values) { [15, 23, 10, 17, 28] }
    let(:this_month_visit_values) { [34, 63, 19, 11] }
    let(:first_day_of_last_month) { first_day_of_month.last_month }
    let(:first_day_of_month) { Time.zone.now.beginning_of_month.to_date }
    let(:last_month_timestamps) { first_day_of_last_month..first_day_of_last_month.next_day(4) }
    let(:this_month_timestamps) { first_day_of_month..first_day_of_month.next_day(3) }
    let(:language_visits_hash) do
      a_hash_including(
        name: language.name.titlecase,
        data: a_hash_including(
          first_day_of_last_month.strftime('%B %Y') => last_month_visit_values.sum,
          first_day_of_month.strftime('%B %Y') => this_month_visit_values.sum
        )
      )
    end

    before do
      values_and_timestamps = last_month_visit_values.zip(last_month_timestamps) +
                              this_month_visit_values.zip(this_month_timestamps)
      create_visits_metrics(project, values_and_timestamps)
    end

    it 'returns the monthly visits grouped by language' do
      expect(described_class.call.datasets).to include(language_visits_hash)
    end
  end

  def create_visits_metrics(project, values_and_timestamps)
    values_and_timestamps.each do |value, timestamp|
      create(
        :metric,
        name: Metric.names[:open_source_visits],
        interval: Metric.intervals[:daily],
        ownable: project,
        value: value,
        value_timestamp: timestamp
      )
    end
  end
end
