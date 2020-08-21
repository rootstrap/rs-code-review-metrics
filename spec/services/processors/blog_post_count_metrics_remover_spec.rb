require 'rails_helper'

RSpec.describe Processors::BlogPostCountMetricsRemover do
  describe '.call' do
    let!(:blog_post_count_metric) { create(:metric, name: Metric.names[:blog_post_count]) }
    let!(:blog_visits_metric) { create(:metric, name: Metric.names[:blog_visits]) }
    let!(:review_turnaround_metric) { create(:metric, name: Metric.names[:review_turnaround]) }
    let!(:merge_time_metric) { create(:metric, name: Metric.names[:merge_time]) }
    let!(:open_source_visits_metric) { create(:metric, name: Metric.names[:open_source_visits]) }

    let(:remaining_metrics) do
      [blog_visits_metric, review_turnaround_metric, merge_time_metric, open_source_visits_metric]
    end

    it 'deletes all blog_post_count metrics' do
      described_class.call

      expect(Metric.all).to match_array(remaining_metrics)
    end
  end
end
