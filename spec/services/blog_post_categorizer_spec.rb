require 'rails_helper'

RSpec.describe BlogPostCategorizer do
  describe '#technologies_for' do
    let!(:ruby_technology) do
      create(:technology, name: 'ruby', keyword_string: 'ruby,rails')
    end
    let!(:python_technology) do
      create(:technology, name: 'python', keyword_string: 'python,django')
    end
    let!(:other_technology) { create(:technology, name: 'other', keyword_string: '') }

    context 'when there is no matching technology for the post' do
      let(:blog_post_payload) { create(:blog_post_payload).with_indifferent_access }

      it 'returns the "other" technology' do
        expect(subject.technologies_for(blog_post_payload)).to contain_exactly other_technology
      end
    end

    context 'when there is a technology matching the post tags' do
      let(:tags) { { 'Ruby': {} } }
      let(:blog_post_payload) do
        create(:blog_post_payload, tags: tags).with_indifferent_access
      end

      it 'returns the matching technology' do
        expect(subject.technologies_for(blog_post_payload)).to contain_exactly ruby_technology
      end
    end

    context 'when there is a technology matching the post categories' do
      let(:categories) { { 'Rails': {} } }
      let(:blog_post_payload) do
        create(:blog_post_payload, categories: categories).with_indifferent_access
      end

      it 'returns the matching technology' do
        expect(subject.technologies_for(blog_post_payload)).to contain_exactly ruby_technology
      end
    end

    context 'when there is more than one technology matching the post tags or categories' do
      let(:tags) { { 'Ruby': {}, 'Python': {} } }
      let(:blog_post_payload) do
        create(:blog_post_payload, tags: tags).with_indifferent_access
      end

      it 'returns all matching technologies' do
        expect(subject.technologies_for(blog_post_payload))
          .to contain_exactly(ruby_technology, python_technology)
      end
    end

    context 'when there is a single technology matching more than one tag or category' do
      let(:tags) { { 'Ruby': {} } }
      let(:categories) { { 'Rails': {} } }
      let(:blog_post_payload) do
        create(:blog_post_payload, tags: tags, categories: categories).with_indifferent_access
      end

      it 'returns that technology only once' do
        expect(subject.technologies_for(blog_post_payload)).to contain_exactly ruby_technology
      end
    end
  end
end
