require 'rails_helper'

describe Processors::BlogPostsFullUpdater do
  describe '.call' do
    context 'when there is already a blog post stored in the DB' do
      let(:api_service) { instance_double(WordpressService) }
      let(:publish_date) { Faker::Time.backward }
      let!(:stored_blog_post) { create(:blog_post, published_at: publish_date) }
      let(:updated_slug) { 'newly-updated-slug' }
      let(:stored_blog_post_payload) do
        create(
          :blog_post_payload,
          ID: stored_blog_post.blog_id,
          date: publish_date.iso8601,
          slug: updated_slug
        ).with_indifferent_access
      end
      let(:new_blog_post_payload) do
        create(
          :blog_post_payload,
          date: publish_date.next_week.iso8601
        ).with_indifferent_access
      end
      let(:blog_post_payload) { [stored_blog_post_payload, new_blog_post_payload] }

      before do
        allow_any_instance_of(described_class)
          .to receive(:wordpress_service)
          .and_return(api_service)
        allow(api_service).to receive(:blog_posts).and_return(blog_post_payload)
        create(:technology, name: 'other')
      end

      it 'updates the stored blog post' do
        described_class.call
        expect { stored_blog_post.reload }.to change(stored_blog_post, :slug)
      end
    end
  end
end
