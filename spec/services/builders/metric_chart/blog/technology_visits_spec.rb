require 'rails_helper'

describe Builders::MetricChart::Blog::TechnologyVisits do
  describe '.call' do
    let(:technology) { create(:technology) }
    let!(:last_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits],
        value: 10,
        value_timestamp: Time.zone.now.last_month.end_of_month
      )
    end
    let!(:this_month_metric) do
      create(
        :metric,
        ownable: technology,
        interval: Metric.intervals[:monthly],
        name: Metric.names[:blog_visits],
        value: 5,
        value_timestamp: Time.zone.now.end_of_month
      )
    end
    let(:technology_metrics_hash) do
      a_hash_including(
        name: technology.name.titlecase,
        data: a_hash_including(
          last_month_metric.value_timestamp.strftime('%B %Y') => last_month_metric.value,
          this_month_metric.value_timestamp.strftime('%B %Y') => this_month_metric.value
        )
      )
    end

    it 'returns the technology visits formatted by technology and month' do
      expect(described_class.call.datasets).to include(technology_metrics_hash)
    end
  end

  describe 'totals' do
    context 'when a blog post has more than one technology' do
      let(:technology_1) { create(:technology) }
      let(:technology_2) { create(:technology) }
      let!(:blog_post) { create(:blog_post, technologies: [technology_1, technology_2]) }
      let(:current_month_timestamp) { Time.zone.now.end_of_month }
      let(:current_month_key) { current_month_timestamp.strftime('%B %Y') }

      before do
        create(
          :metric,
          ownable: blog_post,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
          value: 10,
          value_timestamp: current_month_timestamp
        )
        create(
          :metric,
          ownable: technology_1,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
          value: 10,
          value_timestamp: current_month_timestamp
        )
        create(
          :metric,
          ownable: technology_2,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
          value: 10,
          value_timestamp: current_month_timestamp
        )
      end

      it 'the totals hash only counts the blog post visits once' do
        expect(described_class.call.totals[:data][current_month_key]).to eq 10
      end
    end
  end
end
