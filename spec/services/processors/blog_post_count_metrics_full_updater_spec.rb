require 'rails_helper'

describe Processors::BlogPostCountMetricsFullUpdater do
  describe '.call' do
    context 'when there are already metrics generated' do
      let(:publish_date) { Time.zone.now.last_month }
      let(:technology) { create(:technology) }
      let!(:blog_post) do
        create(:blog_post, published_at: publish_date, technologies: [technology])
      end

      before do
        create(
          :metric,
          name: Metric.names[:blog_post_count],
          interval: Metric.intervals[:monthly],
          ownable: technology,
          value: 1,
          value_timestamp: publish_date.end_of_month
        )
        create(
          :metric,
          name: Metric.names[:blog_post_count],
          interval: Metric.intervals[:monthly],
          ownable: technology,
          value: 1,
          value_timestamp: publish_date.next_month.end_of_month
        )
      end

      it 'still tries to update all of them' do
        expect(Metric).to receive(:find_or_initialize_by).twice.and_call_original

        described_class.call
      end
    end
  end
end
