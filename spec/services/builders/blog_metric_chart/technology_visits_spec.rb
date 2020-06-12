require 'rails_helper'

describe Builders::BlogMetricChart::TechnologyVisits do
  describe '.call' do
    let(:technology) { create(:technology) }
    let!(:last_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits],
        value: 10,
        value_timestamp: Time.zone.now.last_month.end_of_month
      )
    end
    let!(:this_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits],
        value: 5,
        value_timestamp: Time.zone.now.end_of_month
      )
    end
    let(:technology_metrics_hash) do
      {
        name: technology.name.titlecase,
        data: a_hash_including(
          last_month_metric.value_timestamp.strftime('%B %Y') => last_month_metric.value,
          this_month_metric.value_timestamp.strftime('%B %Y') => this_month_metric.value
        )
      }
    end

    it 'returns the technology visits formatted by technology and month' do
      expect(described_class.call).to include(technology_metrics_hash)
    end
  end
end
