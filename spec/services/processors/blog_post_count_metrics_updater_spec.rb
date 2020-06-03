require 'rails_helper'

RSpec.describe Processors::BlogPostCountMetricsUpdater do
  describe '.call' do
    let(:technology) { create(:technology) }
    let!(:blog_post) do
      create(:blog_post, published_at: Time.zone.now, technology: technology)
    end

    it 'creates a blog post count metric for that technology' do
      described_class.call

      metric = Metric.find_by!(
        name: Metric.names[:blog_post_count],
        interval: Metric.intervals[:monthly],
        ownable: technology
      )
      expect(metric.value).to eq 1
      expect(metric.value_timestamp.to_s).to eq Time.zone.now.end_of_month.to_s
    end

    context 'having more than one technology' do
      let(:other_technology) { create(:technology) }
      let!(:other_blog_post) do
        create(:blog_post, published_at: Time.zone.now, technology: other_technology)
      end

      it 'creates metrics for all of them' do
        expect { described_class.call }.to change { Metric.count }.by 2
      end
    end

    context 'when there is already an existing blog_post_count metric in the month' do
      let!(:blog_post_count_metric) do
        create(
          :metric,
          name: Metric.names[:blog_post_count],
          interval: Metric.intervals[:monthly],
          ownable: technology,
          value: 0,
          value_timestamp: Time.zone.now.end_of_month
        )
      end

      it 'updates it' do
        expect { described_class.call }
          .to change { blog_post_count_metric.reload.value }
          .from(0)
          .to(1)
      end
    end

    context 'when there are blog posts published in different months' do
      let!(:older_blog_post) do
        create(:blog_post, published_at: Time.zone.now.last_month, technology: technology)
      end

      it 'creates a metric for every month' do
        expect { described_class.call }.to change { Metric.count }.by 2
      end

      it 'calculates the metrics values by the amount of blog posts published up to that month' do
        described_class.call

        last_month_metric = Metric.find_by!(
          name: Metric.names[:blog_post_count],
          interval: Metric.intervals[:monthly],
          ownable: technology,
          value_timestamp: Time.zone.now.last_month.end_of_month
        )
        this_month_metric = Metric.find_by!(
          name: Metric.names[:blog_post_count],
          interval: Metric.intervals[:monthly],
          ownable: technology,
          value_timestamp: Time.zone.now.end_of_month
        )

        expect(last_month_metric.value).to eq 1
        expect(this_month_metric.value).to eq 2
      end
    end
  end
end
