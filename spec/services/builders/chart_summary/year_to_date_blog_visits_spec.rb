require 'rails_helper'

describe Builders::ChartSummary::YearToDateBlogVisits do
  describe '.call' do
    let(:technology) { create(:technology) }
    let!(:last_year_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 100,
        value_timestamp: Time.zone.now.last_year.end_of_month
      )
    end
    let!(:this_year_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 50,
        value_timestamp: Time.zone.now.end_of_month
      )
    end

    it 'returns the total number of visits for the current year' do
      expect(described_class.call).to eq this_year_metric.value
    end
  end
end
