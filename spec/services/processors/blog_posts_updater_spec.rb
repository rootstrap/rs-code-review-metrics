require 'rails_helper'

RSpec.describe Processors::BlogPostsUpdater do
  describe '#call' do
    let(:api_service) { instance_double(WordpressService) }
    let(:blog_post_payload) do
      [
        {
          'ID': 4424,
          'site_ID': 166779230,
          'date': '2020-01-14T19:32:09+00:00',
          'title': 'Rootstrap named Top Staff Augmentation Company by Clutch',
          'URL': 'https://www.rootstrap.com/blog/2020/01/14/rootstrap-named-top-staff-augmentation-company-by-clutch/',
          'short_URL': 'https://www.rootstrap.com/blog/?p=4424',
          'slug': 'rootstrap-named-top-staff-augmentation-company-by-clutch',
          'status': 'publish',
          'tags': {},
          'categories': {}
        }
      ]
    end

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
