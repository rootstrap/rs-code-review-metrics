require 'rails_helper'

describe MetricsDatasetGroup do
  let(:technology) { create(:technology) }
  let!(:blog_post) { create(:blog_post, published_at: Time.zone.now, technologies: [technology]) }
  let!(:this_month_post_count_metric) do
    create(
      :metric,
      name: Metric.names[:blog_post_count],
      interval: Metric.intervals[:monthly],
      ownable: technology,
      value: 1,
      value_timestamp: Time.zone.now.end_of_month
    )
  end

  let(:datasets) { blog_metrics_dataset_group.datasets }
  let(:totals) { blog_metrics_dataset_group.totals }
  subject(:blog_metrics_dataset_group) { Builders::MetricChart::Blog::TechnologyBlogPostCount.call }

  describe '#all_datasets' do
    it 'returns datasets including the totals' do
      expect(blog_metrics_dataset_group.all_datasets).to match_array(datasets + [totals])
    end
  end

  describe '#totals_for' do
    let(:date) { Time.zone.now }

    it 'returns the totals value matching the given date' do
      expect(blog_metrics_dataset_group.totals_for(date)).to eq this_month_post_count_metric.value
    end
  end
end
