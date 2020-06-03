require 'rails_helper'

RSpec.describe Processors::BlogTechnologyViewsPartialUpdater do
  describe '.call' do
    let!(:technology) { create(:technology) }
    let(:metric_timestamp) { Time.zone.now.end_of_month }
    let(:blog_post) { create(:blog_post, technology: technology) }
    let!(:blog_post_views_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: metric_timestamp,
        ownable: blog_post
      )
    end
    let!(:last_month_blog_post_views_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: metric_timestamp.last_month,
        ownable: blog_post
      )
    end

    context 'when technologies visits metrics have been registered' do
      before do
        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value: last_month_blog_post_views_metric.value,
          value_timestamp: metric_timestamp.last_month,
          ownable: technology
        )

        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value: blog_post_views_metric.value,
          value_timestamp: metric_timestamp,
          ownable: technology
        )
      end

      it 'just tries to update the last of them' do
        expect(Metric).to receive(:find_or_initialize_by).once.and_call_original

        described_class.call
      end
    end
  end
end
