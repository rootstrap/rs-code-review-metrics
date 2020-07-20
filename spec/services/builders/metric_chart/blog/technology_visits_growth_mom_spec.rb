require 'rails_helper'

describe Builders::MetricChart::Blog::TechnologyVisitsGrowthMom do
  describe '.call' do
    let(:technology) { create(:technology) }
    let(:blog_post) { create(:blog_post, technologies: [technology]) }
    let(:current_month_timestamp) { Time.zone.now.end_of_month }
    let(:last_month_timestamp) { current_month_timestamp.last_month }
    let(:current_month_key) { current_month_timestamp.strftime('%B %Y') }
    let(:last_month_value) { 100 }
    let!(:last_month_blog_post_metric) do
      create_visits_metric(blog_post, last_month_value, last_month_timestamp)
    end
    let!(:current_month_blog_post_metric) do
      create_visits_metric(blog_post, 120, current_month_timestamp)
    end

    before do
      create_visits_metric(technology, last_month_value, last_month_timestamp)
      create_visits_metric(technology, 120, current_month_timestamp)
    end

    it 'returns a hash with the growth month over month rate of the given metric' do
      expect(described_class.call(1).datasets)
        .to include(a_hash_including(data: a_hash_including(current_month_key => 20)))
    end

    context 'when last month metric was 0' do
      let(:last_month_value) { 0 }

      it 'this month metric is not calculated' do
        expect(described_class.call(1).datasets)
          .not_to include(a_hash_including(data: a_hash_including(current_month_key)))
      end
    end

    describe 'totals' do
      let(:other_technology) { create(:technology) }
      let(:other_blog_post) { create(:blog_post, technologies: [other_technology]) }
      let!(:last_month_other_blog_post_metric) do
        create_visits_metric(other_blog_post, 100, last_month_timestamp)
      end
      let!(:current_month_other_blog_post_metric) do
        create_visits_metric(other_blog_post, 100, current_month_timestamp)
      end
      let(:totals_hash) do
        a_hash_including(
          name: 'Totals',
          data: a_hash_including(
            current_month_key => 10
          )
        )
      end

      before do
        create_visits_metric(other_technology, 100, last_month_timestamp)
        create_visits_metric(other_technology, 100, current_month_timestamp)
      end

      it 'returns a hash with the growth month over month rate of each month total visits' do
        expect(described_class.call(1).totals).to match(totals_hash)
      end

      context 'when there are blog posts with more than one technology' do
        let(:other_blog_post) { create(:blog_post, technologies: [technology, other_technology]) }
        let!(:last_month_blog_post_metric) do
          create_visits_metric(blog_post, 0, last_month_timestamp)
        end
        let!(:current_month_blog_post_metric) do
          create_visits_metric(blog_post, 20, current_month_timestamp)
        end

        it 'the totals hash only counts those blog posts visits once' do
          expect(described_class.call.totals[:data][current_month_key]).to eq 20
        end
      end
    end
  end

  def create_visits_metric(ownable, value, timestamp)
    create(
      :metric,
      name: Metric.names[:blog_visits],
      interval: Metric.intervals[:monthly],
      ownable: ownable,
      value: value,
      value_timestamp: timestamp
    )
  end
end
