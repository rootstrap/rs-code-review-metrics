require 'rails_helper'

RSpec.describe BlogPostCategorizer do
  describe '#technology_for' do
    let!(:ruby_technology) { create(:technology, name: 'ruby', keyword_string: 'ruby,rails') }
    let!(:python_technology) { create(:technology, name: 'python', keyword_string: 'python,django') }
    let!(:other_technology) { create(:technology, name: 'other', keyword_string: '') }
    let(:blog_post_payload) do
      {
        'ID': 5043,
        'site_ID': 166779230,
        'date': '2020-04-16T20:24:58+00:00',
        'title': 'Introducing yaaf',
        'URL': 'https://www.rootstrap.com/blog/2020/04/16/introducing-yaaf/',
        'short_URL': 'https://www.rootstrap.com/blog/?p=5043',
        'slug': 'introducing-yaaf',
        'status': 'publish',
        'tags': tags,
        'categories': categories
      }
    end
    let(:tags) { {} }
    let(:categories) { {} }

    context 'when there is no matching technology for the post' do
      it 'returns the "other" technology' do
        expect(subject.technology_for(blog_post_payload)).to eq other_technology
      end
    end

    context 'when there is a technology matching the post tags' do
      let(:tags) { { 'Ruby': {} } }

      it 'returns the matching technology' do
        expect(subject.technology_for(blog_post_payload)).to eq ruby_technology
      end
    end

    context 'when there is a technology matching the post categories' do
      let(:categories) { { 'Rails': {} } }

      it 'returns the matching technology' do
        expect(subject.technology_for(blog_post_payload)).to eq ruby_technology
      end
    end
  end
end