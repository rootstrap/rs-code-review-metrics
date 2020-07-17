require 'rails_helper'

describe Builders::MetricChart::Base do
  subject { Builders::MetricChart::Blog::TechnologyVisits }

  describe '.call' do
    describe 'totals' do
      let(:technology_1) { create(:technology) }
      let(:technology_2) { create(:technology) }
      let!(:metric_1) do
        create(
          :metric,
          ownable: technology_1,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
          value_timestamp: Time.zone.now.end_of_month
        )
      end
      let!(:metric_2) do
        create(
          :metric,
          ownable: technology_2,
          interval: Metric.intervals[:monthly],
          name: Metric.names[:blog_visits],
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
        expect(subject.call.totals).to match(totals_hash)
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
        expect(subject.call.datasets).to all(satisfy do |dataset|
          dataset[:dataset][:hidden] == true
        end)
      end

      it 'the totals dataset is not hidden' do
        expect(subject.call.totals[:dataset][:hidden]).to eq false
      end
    end
  end

  describe 'abstract methods' do
    subject { described_class.send(:new) }

    describe '#entities' do
      it_behaves_like 'abstract method', :entities, 0
    end

    describe '#entity_name' do
      it_behaves_like 'abstract method', :entity_name, 1
    end

    describe '#entity_metrics' do
      it_behaves_like 'abstract method', :entity_metrics, 1
    end

    describe '#metric_ownable_type' do
      it_behaves_like 'abstract method', :metric_ownable_type, 0
    end

    describe '#metric_name' do
      it_behaves_like 'abstract method', :metric_name, 0
    end

    describe '#metric_interval' do
      it_behaves_like 'abstract method', :metric_interval, 0
    end

    describe '#chart_date_format' do
      it_behaves_like 'abstract method', :chart_date_format, 0
    end

    describe '#grouping_period' do
      it_behaves_like 'abstract method', :grouping_period, 0
    end
  end
end
