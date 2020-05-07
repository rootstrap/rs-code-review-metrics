require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '.call' do
    let(:api_service) { instance_double(WordpressService) }
    let(:blog_post_payload) { [create(:blog_post_payload).with_indifferent_access] }

    before do
      allow_any_instance_of(described_class).to receive(:wordpress_service).and_return(api_service)
      allow(api_service).to receive(:blog_posts).and_return(blog_post_payload)
      create(:technology, name: 'other')
    end

    it 'saves all blog posts in the db' do
      expect { described_class.call }.to change(BlogPost, :count).by(1)
    end

    context 'when the post has already been imported' do
      before { described_class.call }

      it 'does not create another blog post' do
        expect { described_class.call }.not_to change(BlogPost, :count)
      end
    end

    context 'when there is already a blog post stored in the DB' do
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

      context 'and it is requested to do a full update' do
        it 'updates the stored blog post' do
          described_class.call(full_update: true)
          expect { stored_blog_post.reload }.to change(stored_blog_post, :slug)
        end
      end

      context 'and it is not requested to do a full update' do
        let(:partial_blog_post_payload) { [new_blog_post_payload] }

        before do
          allow(api_service)
            .to receive(:blog_posts)
            .with(since: publish_date)
            .and_return(partial_blog_post_payload)
        end

        it 'does not update the stored blog post' do
          described_class.call(full_update: false)
          expect { stored_blog_post.reload }.not_to change(stored_blog_post, :slug)
        end
      end
    end
  end
end
