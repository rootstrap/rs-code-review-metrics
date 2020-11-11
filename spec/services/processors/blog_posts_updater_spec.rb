require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '.call' do
    subject { Processors::BlogPostsFullUpdater.call }

    let(:blog_post_payload) { create(:blog_post_payload) }

    before do
      create(:technology, name: 'other')
      stub_blog_posts_response(blog_post_payloads: [blog_post_payload])
    end

    context 'when all requests succeed' do
      before do
        stub_successful_blog_post_response(blog_post_payload)
      end

      it 'saves all blog posts in the db' do
        expect { subject }.to change(BlogPost, :count).by(1)
      end

      context 'when the post has already been imported' do
        before { subject }

        it 'does not create another blog post' do
          expect { subject }.not_to change(BlogPost, :count)
        end
      end
    end
  end
end
