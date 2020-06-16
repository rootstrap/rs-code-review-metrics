require 'rails_helper'

RSpec.describe TechnologyGrowthMomCalculator do
  describe '.call' do
    let(:technology) { create(:technology) }
    let(:metric_name) { Metric.names[:blog_visits] }
    let(:last_month_value) { 100 }

    before do
      create(
        :metric,
        name: metric_name,
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: last_month_value,
        value_timestamp: Time.zone.now.last_month.end_of_month
      )
      create(
        :metric,
        name: metric_name,
        interval: Metric.intervals[:monthly],
        ownable: technology,
        value: 120,
        value_timestamp: Time.zone.now.end_of_month
      )
    end

    it 'returns a hash with the growth month over month rate of the given metric' do
      expect(described_class.call(metric_name, 1))
        .to include(a_hash_including(data: a_hash_including(Time.zone.now.strftime('%B %Y') => 20)))
    end

    context 'when last month metric was 0' do
      let(:last_month_value) { 0 }

      it 'this month metric is not calculated' do
        expect(described_class.call(metric_name, 1))
          .not_to include(a_hash_including(data: a_hash_including(Time.zone.now.strftime('%B %Y'))))
      end
    end

    describe 'totals' do
      let(:other_tecnology) { create(:technology) }
      let(:totals_hash) do
        {
          name: 'Totals',
          data: a_hash_including(
            Time.zone.now.strftime('%B %Y') => 10
          )
        }
      end

      before do
        create(
          :metric,
          name: metric_name,
          interval: Metric.intervals[:monthly],
          ownable: other_tecnology,
          value: 100,
          value_timestamp: Time.zone.now.last_month.end_of_month
        )
        create(
          :metric,
          name: metric_name,
          interval: Metric.intervals[:monthly],
          ownable: other_tecnology,
          value: 100,
          value_timestamp: Time.zone.now.end_of_month
        )
      end

      it 'returns a hash with the growth month over month rate of each month total visits' do
        expect(described_class.call(metric_name, 1)).to include(totals_hash)
      end
    end
  end
end
