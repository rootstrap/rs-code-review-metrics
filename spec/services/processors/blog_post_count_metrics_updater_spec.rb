require 'rails_helper'

RSpec.describe Processors::BlogPostCountMetricsUpdater do
  describe '.call' do
    let(:technology) { create(:technology) }
    let(:publish_time) { Time.zone.now }

    before do
      create(:blog_post, published_at: publish_time, technology: technology)
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
      before do
        other_technology = create(:technology)
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
      before do
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

    context 'when there is a month without new blog posts' do
      context 'and it is the latest' do
        let(:empty_month_timestamp) { Time.zone.now }
        let(:publish_time) { empty_month_timestamp.last_month }

        it 'adds the metric for that month with the unchanged value' do
          described_class.call

          empty_month_metric = Metric.find_by!(
            name: Metric.names[:blog_post_count],
            interval: Metric.intervals[:monthly],
            ownable: technology,
            value_timestamp: empty_month_timestamp.end_of_month
          )
          expect(empty_month_metric.value).to eq 1
        end
      end

      context 'and it is between other months with new blog posts' do
        let(:empty_month_timestamp) { Time.zone.now.last_month }
        let(:publish_time) { empty_month_timestamp.last_month }

        before do
          create(:blog_post, published_at: empty_month_timestamp.next_month, technology: technology)
        end

        it 'adds the metric for that month with the unchanged value' do
          described_class.call

          empty_month_metric = Metric.find_by!(
            name: Metric.names[:blog_post_count],
            interval: Metric.intervals[:monthly],
            ownable: technology,
            value_timestamp: empty_month_timestamp.end_of_month
          )
          expect(empty_month_metric.value).to eq 1
        end
      end

      context 'and it is at the start of the period queried' do
        let(:empty_month_timestamp) { Time.zone.now.last_month }

        before do
          other_technology = create(:technology)
          create(:blog_post, published_at: empty_month_timestamp, technology: other_technology)
        end

        it 'adds the metric for that month with the unchanged value' do
          described_class.call

          empty_month_metric = Metric.find_by!(
            name: Metric.names[:blog_post_count],
            interval: Metric.intervals[:monthly],
            ownable: technology,
            value_timestamp: empty_month_timestamp.end_of_month
          )
          expect(empty_month_metric.value).to eq 0
        end
      end
    end
  end
end
