require 'rails_helper'

describe Processors::BlogMetricsUpdater do
  describe '.call' do
    let(:technology) { create(:technology) }
    let!(:blog_post) { create(:blog_post, technology: technology) }
    let(:blog_post_views_payload) { create(:blog_post_views_payload) }

    before do
      stub_blog_post_views_response(blog_post.blog_id, blog_post_views_payload)
    end

    it 'updates blog post visits metrics' do
      described_class.call

      metric = Metric.find_by!(
        ownable: blog_post,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits]
      )

      expect(metric).to be_present
    end

    it 'updates technologies visits metrics' do
      described_class.call

      metric = Metric.find_by!(
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits]
      )

      expect(metric).to be_present
    end
  end

  describe '#update_blog_post_visits_metrics' do
    let!(:blog_post_1) { create(:blog_post) }
    let!(:blog_post_2) { create(:blog_post) }
    let(:blog_post_views_payload_1) { create(:blog_post_views_payload) }
    let(:blog_post_views_payload_2) { create(:blog_post_views_payload) }
    let(:total_metrics_generated) do
      months_count_for(blog_post_views_payload_1) + months_count_for(blog_post_views_payload_2)
    end

    subject { described_class.send(:new).send(:update_blog_post_visits_metrics) }

    before do
      stub_blog_post_views_response(blog_post_1.blog_id, blog_post_views_payload_1)
      stub_blog_post_views_response(blog_post_2.blog_id, blog_post_views_payload_2)
    end

    it 'updates visits metrics for all blog posts' do
      expect { subject }.to change(Metric, :count).by total_metrics_generated
    end
  end

  describe '#update_technologies_visits_metrics' do
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

    subject { described_class.send(:new).send(:update_technologies_visits_metrics) }

    it 'creates the technologies visits metric' do
      subject

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
        expect { subject }.to change { technology_visits_metric.reload.value }.to technology_visits
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
        expect { subject }.to change { Metric.count }.by 2
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
        expect { subject }.to change { Metric.count }.by 2
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

          subject
        end
      end
    end
  end
end

def months_count_for(blog_post_views_payload)
  blog_post_views_payload['years'].sum do |_year, year_hash|
    year_hash['months'].count
  end
end
