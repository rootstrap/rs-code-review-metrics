require 'rails_helper'

describe Processors::BlogTechnologyViewsUpdater do
  describe '#call' do
    let!(:technology) { create(:technology) }
    let(:metric_timestamp) { Time.zone.now.end_of_month }
    let(:blog_post_1) { create(:blog_post, technology: technology) }
    let!(:blog_post_1_views_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: metric_timestamp,
        ownable: blog_post_1
      )
    end
    let(:blog_post_2) { create(:blog_post, technology: technology) }
    let!(:blog_post_2_views_metric) do
      create(
        :metric,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly],
        value_timestamp: metric_timestamp,
        ownable: blog_post_2
      )
    end
    let(:technology_visits) { blog_post_1_views_metric.value + blog_post_2_views_metric.value }

    it 'creates the technologies visits metric' do
      described_class.call

      metric = Metric.find_by!(
        ownable: technology,
        name: Metric.names[:blog_visits],
        interval: Metric.intervals[:monthly]
      )
      expect(metric.value).to eq technology_visits
      expect(metric.value_timestamp.to_s).to eq blog_post_1_views_metric.value_timestamp.to_s
    end

    context 'when the metric is already present' do
      let!(:technology_visits_metric) do
        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value_timestamp: metric_timestamp,
          ownable: technology,
          value: technology_visits - 10
        )
      end

      it 'updates it with the latest info' do
        expect { described_class.call }
          .to change { technology_visits_metric.reload.value }
          .to technology_visits
      end
    end

    context 'when there is more than one technology' do
      let!(:technology_2) { create(:technology) }
      let(:blog_post_for_tech_2) { create(:blog_post, technology: technology_2) }
      let!(:blog_post_for_tech_2_views_metric) do
        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value_timestamp: metric_timestamp,
          ownable: blog_post_for_tech_2
        )
      end

      it 'creates metrics for all of them' do
        expect { described_class.call }.to change { Metric.count }.by 2
      end
    end

    context 'when there are blog post views metrics for more than 1 month' do
      let!(:last_month_blog_post_1_views_metric) do
        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value_timestamp: metric_timestamp.last_month,
          ownable: blog_post_1
        )
      end

      it 'creates a technology metric for each one of those months' do
        expect { described_class.call }.to change { Metric.count }.by 2
      end

      context 'but technologies visits metrics have already been registered' do
        before do
          create(
            :metric,
            name: Metric.names[:blog_visits],
            interval: Metric.intervals[:monthly],
            value: last_month_blog_post_1_views_metric.value,
            value_timestamp: metric_timestamp.last_month,
            ownable: technology
          )

          create(
            :metric,
            name: Metric.names[:blog_visits],
            interval: Metric.intervals[:monthly],
            value: technology_visits,
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
end
