require 'rails_helper'

describe Builders::MetricChart::Blog::TechnologyBlogPostCount do
  describe '.call' do
    let(:technology) { create(:technology) }
    let(:last_month_timestamp) { this_month_timestamp.last_month }
    let(:last_month_blog_post_count) { 4 }
    let(:this_month_timestamp) { Time.zone.now.beginning_of_month }
    let(:this_month_blog_post_count) { 6 }

    before do
      create_list(
        :blog_post,
        last_month_blog_post_count,
        published_at: last_month_timestamp,
        technologies: [technology]
      )
      create_list(
        :blog_post,
        this_month_blog_post_count,
        published_at: this_month_timestamp,
        technologies: [technology]
      )
    end

    let(:technology_metrics_hash) do
      a_hash_including(
        name: technology.name.titlecase,
        data: a_hash_including(
          last_month_timestamp.strftime('%B %Y') => last_month_blog_post_count,
          this_month_timestamp.strftime('%B %Y') => this_month_blog_post_count
        )
      )
    end

    it 'returns the blog post count per technology formatted by technology and month' do
      expect(described_class.call.datasets).to include(technology_metrics_hash)
    end
  end

  describe 'totals' do
    context 'when a blog post has more than one technology' do
      let(:technology_1) { create(:technology) }
      let(:technology_2) { create(:technology) }
      let!(:blog_post) do
        create(:blog_post, technologies: [technology_1, technology_2], published_at: now)
      end
      let(:now) { Time.zone.now }
      let(:current_month_key) { now.strftime('%B %Y') }

      it 'the totals hash only counts the blog post once' do
        expect(described_class.call.totals[:data][current_month_key]).to eq 1
      end
    end

    describe 'periods returned' do
      let(:technology) { create(:technology) }
      let(:periods) { 13 }

      before do
        create(:blog_post, published_at: 3.years.ago, technologies: [technology])
      end

      it 'returns only the requested amount of periods' do
        expect(described_class.call(periods).totals[:data].count).to eq periods
      end
    end
  end
end
