require 'rails_helper'

describe Builders::BlogMetricChart::Base do
  subject { Builders::BlogMetricChart::TechnologyBlogPostCount }

  describe '.call' do
    describe 'totals' do
      let(:technology_1) { create(:technology) }
      let(:technology_2) { create(:technology) }
      let!(:metric_1) do
        create(
          :metric,
          ownable: technology_1,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_post_count],
          value_timestamp: Time.zone.now.end_of_month
        )
      end
      let!(:metric_2) do
        create(
          :metric,
          ownable: technology_2,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_post_count],
          value_timestamp: Time.zone.now.end_of_month
        )
      end
      let(:totals_hash) do
        {
          name: 'Totals',
          data: a_hash_including(
            Time.zone.now.strftime('%B %Y') => metric_1.value + metric_2.value
          )
        }
      end

      it 'includes each month totals in the hash response' do
        expect(subject.call).to include(totals_hash)
      end
    end
  end
end
