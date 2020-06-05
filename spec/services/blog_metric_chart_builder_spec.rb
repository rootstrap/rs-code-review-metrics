require 'rails_helper'

describe BlogMetricChartBuilder do
  describe '#technology_visits' do
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
        data: {
          last_month_metric.value_timestamp.strftime('%B %Y') => last_month_metric.value,
          this_month_metric.value_timestamp.strftime('%B %Y') => this_month_metric.value
        }
      }
    end

    it 'returns the technology visits formatted by technology and month' do
      expect(subject.technology_visits).to contain_exactly(technology_metrics_hash)
    end
  end

  describe '#technology_blog_post_count' do
    let(:technology) { create(:technology) }
    let!(:last_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_post_count],
        value: 4,
        value_timestamp: Time.zone.now.last_month.end_of_month
      )
    end
    let!(:this_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_post_count],
        value: 10,
        value_timestamp: Time.zone.now.end_of_month
      )
    end

    let(:technology_metrics_hash) do
      {
        name: technology.name.titlecase,
        data: {
          last_month_metric.value_timestamp.strftime('%B %Y') => last_month_metric.value,
          this_month_metric.value_timestamp.strftime('%B %Y') => this_month_metric.value
        }
      }
    end

    it 'returns the blog post count per technology formatted by technology and month' do
      expect(subject.technology_blog_post_count).to contain_exactly(technology_metrics_hash)
    end
  end
end
