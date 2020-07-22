require 'rails_helper'

describe Processors::BlogPostCountMetricsPartialUpdater do
  describe '.call' do
    let(:publish_date) { Time.zone.now.last_month }
    let(:technology) { create(:technology) }
    let!(:blog_post) { create(:blog_post, published_at: publish_date, technologies: [technology]) }

    context 'when there are no metrics generated' do
      it 'generates all of them' do
        expect(Metric).to receive(:find_or_initialize_by).twice.and_call_original

        described_class.call
      end
    end

    context 'when there are already metrics generated' do
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

      it 'only updates the last of them' do
        expect(Metric).to receive(:find_or_initialize_by).once.and_call_original

        described_class.call
      end
    end
  end
end
