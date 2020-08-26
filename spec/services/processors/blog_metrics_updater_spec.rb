require 'rails_helper'

describe Processors::BlogMetricsUpdater do
  describe '.call' do
    let!(:technology) { create(:technology) }
    let(:blog_post_1) { create(:blog_post, technologies: [technology]) }
    let(:blog_post_2) { create(:blog_post, technologies: [technology]) }
    let(:blog_post_views_payload_1) { create(:blog_post_views_payload) }
    let(:blog_post_views_payload_2) { create(:blog_post_views_payload) }
    let(:blog_post_1_month_count) { months_count_for(blog_post_views_payload_1) }
    let(:blog_post_2_month_count) { months_count_for(blog_post_views_payload_2) }

    before do
      stub_successful_blog_post_views_response(blog_post_1.blog_id, blog_post_views_payload_1)
      stub_successful_blog_post_views_response(blog_post_2.blog_id, blog_post_views_payload_2)
    end

    subject(:updater) { Processors::BlogMetricsPartialUpdater }

    describe '#update_blog_post_visits_metrics' do
      let(:total_metrics_generated) { blog_post_1_month_count + blog_post_2_month_count }

      it 'updates visits metrics for all blog posts' do
        expect { updater.call }
          .to change(Metric.where(ownable_type: BlogPost.name), :count)
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

    context 'when there is an error in a request to the Wordpress API' do
      let(:failing_blog_post) { create(:blog_post) }
      let(:succeeding_blog_post) { create(:blog_post) }

      before do
        stub_failed_blog_post_views_response(failing_blog_post.blog_id)
        stub_successful_blog_post_views_response(succeeding_blog_post.blog_id)
      end

      it 'successfully updates the rest of the blog posts' do
        updater.call

        expect(Metric.find_by(ownable: succeeding_blog_post)).not_to be_nil
      end
    end
  end
end

def months_count_for(blog_post_views_payload)
  blog_post_views_payload['years'].sum do |_year, year_hash|
    year_hash['months'].count
  end
end
