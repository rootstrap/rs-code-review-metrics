require 'rails_helper'

describe Processors::BlogMetricsUpdater do
  describe '.call' do
    let!(:technology) { create(:technology) }
    let(:blog_post_1) { create(:blog_post, technology: technology) }
    let(:blog_post_2) { create(:blog_post, technology: technology) }
    let(:blog_post_views_payload_1) { create(:blog_post_views_payload) }
    let(:blog_post_views_payload_2) { create(:blog_post_views_payload) }
    let(:blog_post_1_month_count) { months_count_for(blog_post_views_payload_1) }
    let(:blog_post_2_month_count) { months_count_for(blog_post_views_payload_2) }

    before do
      stub_blog_post_views_response(blog_post_1.blog_id, blog_post_views_payload_1)
      stub_blog_post_views_response(blog_post_2.blog_id, blog_post_views_payload_2)
    end

    subject(:updater) { Processors::BlogMetricsPartialUpdater }

    describe '#update_blog_post_visits_metrics' do
      let(:total_metrics_generated) { blog_post_1_month_count + blog_post_2_month_count }

      it 'updates visits metrics for all blog posts' do
        expect { updater.call }
          .to change(Metric.where(ownable_type: BlogPost.to_s), :count)
          .by total_metrics_generated
      end
    end

    describe '#update_technologies_visits_metrics' do
      let(:total_months_with_blog_post_visits) do
        [blog_post_1_month_count, blog_post_2_month_count].max
      end

      it 'creates as many technology visits metrics as months with blog post visits' do
        expect { updater.call }
          .to change(Metric.where(ownable: technology, name: Metric.names[:blog_visits]), :count)
          .by total_months_with_blog_post_visits
      end
    end

    describe '#update_technologies_blog_post_count_metrics' do
      let(:total_months_since_first_blog_post_published) do
        earliest_publish_date = [blog_post_1.published_at, blog_post_2.published_at].min.to_date
        (earliest_publish_date..Time.zone.today).map(&:beginning_of_month).uniq.count
      end

      it 'creates as many blog post count metrics as months since the first publication' do
        expect { updater.call }
          .to change(
            Metric.where(ownable: technology, name: Metric.names[:blog_post_count]),
            :count
          )
          .by total_months_since_first_blog_post_published
      end
    end
  end
end

def months_count_for(blog_post_views_payload)
  blog_post_views_payload['years'].sum do |_year, year_hash|
    year_hash['months'].count
  end
end
