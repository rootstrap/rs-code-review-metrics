require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '.call' do
    subject { Processors::BlogPostsFullUpdater.call }

    before do
      create(:technology, name: 'other')
      stub_blog_posts_response
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
