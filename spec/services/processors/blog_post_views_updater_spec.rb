require 'rails_helper'

describe Processors::BlogPostViewsUpdater do
  describe '.call' do
    let(:blog_post) { create(:blog_post, published_at: publish_date) }
    let(:blog_post_views_payload) do
      create(:blog_post_views_payload, publish_datetime: publish_date).with_indifferent_access
    end
    let(:publish_date) { Time.zone.now.beginning_of_month }
    let(:current_month_views) do
      blog_post_views_payload['years'][publish_date.year.to_s]['months'][publish_date.month.to_s]
    end
    let(:api_service) { instance_double(WordpressService) }

    before do
      allow_any_instance_of(described_class).to receive(:wordpress_service).and_return(api_service)
      allow(api_service)
        .to receive(:blog_post_views)
        .with(blog_post.blog_id)
        .and_return(blog_post_views_payload)
    end

    it 'creates views metrics for the blog post' do
      described_class.call(blog_post.blog_id)

      created_metric = Metric.find_by(
        ownable: blog_post,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits]
      )
      expect(created_metric.value).to eq current_month_views
      expect(created_metric.value_timestamp.to_s).to eq publish_date.end_of_month.to_s
    end

    context 'when the blog post has already registered views this month' do
      let(:outdated_month_views) { current_month_views - 10 }

      before do
        create(
          :metric,
          name: Metric.names[:blog_visits],
          interval: Metric.intervals[:monthly],
          value: outdated_month_views,
          value_timestamp: publish_date.end_of_month,
          ownable: blog_post
        )
      end

      it 'updates the views amount with the latest info' do
        metric = Metric.find_by(ownable: blog_post)

        expect { described_class.call(blog_post.blog_id) }
          .to change { metric.reload.value }
          .from(outdated_month_views)
          .to(current_month_views)
      end

      context 'and all months since it publication' do
        let(:publish_date) { Time.zone.now.last_year }

        before do
          (publish_date.to_date..Time.zone.today).map(&:end_of_month).uniq.each do |time|
            create(
              :metric,
              name: Metric.names[:blog_visits],
              interval: Metric.intervals[:monthly],
              value: outdated_month_views,
              value_timestamp: time.end_of_day,
              ownable: blog_post
            )
          end
        end

        it 'does not access last month views as they will not have changed' do
          expect(Metric).to receive(:find_or_initialize_by).once.and_call_original

          described_class.call(blog_post.blog_id)
        end
      end
    end
  end
end
