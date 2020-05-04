require 'rails_helper'

RSpec.describe BlogPostCategorizer do
  describe '#technology_for' do
    let!(:ruby_technology) { create(:technology, name: 'ruby', keyword_string: 'ruby,rails') }
    let!(:python_technology) { create(:technology, name: 'python', keyword_string: 'python,django') }
    let!(:other_technology) { create(:technology, name: 'other', keyword_string: '') }

    context 'when there is no matching technology for the post' do
      let(:blog_post_payload) { create(:blog_post_payload).with_indifferent_access }

      it 'returns the "other" technology' do
        expect(subject.technology_for(blog_post_payload)).to eq other_technology
      end
    end

    context 'when there is a technology matching the post tags' do
      let(:tags) { { 'Ruby': {} } }
      let(:blog_post_payload) { create(:blog_post_payload, tags: tags).with_indifferent_access }

      it 'returns the matching technology' do
        expect(subject.technology_for(blog_post_payload)).to eq ruby_technology
      end
    end

    context 'when there is a technology matching the post categories' do
      let(:categories) { { 'Rails': {} } }
      let(:blog_post_payload) { create(:blog_post_payload, categories: categories).with_indifferent_access }

      it 'returns the matching technology' do
        expect(subject.technology_for(blog_post_payload)).to eq ruby_technology
      end
    end
  end
end