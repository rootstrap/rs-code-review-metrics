require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '#call' do
    let(:api_service) { instance_double(WordpressService) }
    let(:blog_post_payload) { [create(:blog_post_payload).with_indifferent_access] }

    before do
      allow(subject).to receive(:wordpress_service).and_return(api_service)
      allow(api_service).to receive(:blog_posts).and_return(blog_post_payload)
      create(:technology, name: 'other')
    end

    it 'saves all blog posts in the db' do
      expect { subject.call }.to change(BlogPost, :count).by(1)
    end
  end
end
