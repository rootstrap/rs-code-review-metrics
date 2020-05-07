require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '.call' do
    let(:api_service) { instance_double(WordpressService) }
    let(:blog_post_payload) { [create(:blog_post_payload).with_indifferent_access] }

    subject { Processors::BlogPostsFullUpdater.call }

    before do
      allow_any_instance_of(described_class).to receive(:wordpress_service).and_return(api_service)
      allow(api_service).to receive(:blog_posts).and_return(blog_post_payload)
      create(:technology, name: 'other')
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
