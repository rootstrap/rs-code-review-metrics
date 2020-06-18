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
        a_hash_including(
          name: 'Totals',
          data: a_hash_including(
            Time.zone.now.strftime('%B %Y') => metric_1.value + metric_2.value
          )
        )
      end

      it 'includes each month totals in the hash response' do
        expect(subject.call).to include(totals_hash)
      end
    end

    describe 'hidden results' do
      let(:technology) { create(:technology) }
      let!(:metric) do
        create(
          :metric,
          ownable: technology,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_post_count],
          value_timestamp: Time.zone.now.end_of_month
        )
      end

      it 'each technology dataset is hidden' do
        technology_dataset = subject.call.find do |dataset|
          dataset[:name] == technology.name.titleize
        end

        expect(technology_dataset[:dataset][:hidden]).to eq true
      end

      it 'the totals dataset is not hidden' do
        totals_dataset = subject.call.find { |dataset| dataset[:name] == 'Totals' }

        expect(totals_dataset[:dataset][:hidden]).to eq false
      end
    end
  end
end
