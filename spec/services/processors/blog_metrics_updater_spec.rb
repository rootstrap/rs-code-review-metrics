require 'rails_helper'

describe Processors::BlogMetricsUpdater do
  describe '#call' do
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

    describe '#update_blog_post_visits_metrics' do
      let(:total_metrics_generated) { blog_post_1_month_count + blog_post_2_month_count }

      it 'updates visits metrics for all blog posts' do
        expect { described_class.call }
          .to change(Metric.where(ownable_type: BlogPost.to_s), :count)
          .by total_metrics_generated
      end
    end

    describe '#update_technologies_visits_metrics' do
      let(:total_months_with_blog_post_visits) do
        [blog_post_1_month_count, blog_post_2_month_count].max
      end

      it 'creates as much technology visits metrics as months with blog post visits' do
        expect { described_class.call }
          .to change(Metric.where(ownable: technology), :count)
          .by total_months_with_blog_post_visits
      end
    end
  end
end

def months_count_for(blog_post_views_payload)
  blog_post_views_payload['years'].sum do |_year, year_hash|
    year_hash['months'].count
  end
end
