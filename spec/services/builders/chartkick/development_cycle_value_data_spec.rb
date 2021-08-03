require 'rails_helper'

describe Builders::Chartkick::DevelopmentCycleValueData do
  subject { described_class.send(:new, 1, '') }

  describe '.build_data' do
    context 'for a given set of metrics' do
      let(:yesterday) { Date.yesterday }
      let(:formatted_yesterday) { yesterday.strftime('%Y-%m-%d') }
      let(:yesterday_development_cycle) { 4 }
      let(:today) { Time.zone.today }
      let(:today_development_cycle) { 50 }
      let(:formatted_today) { today.strftime('%Y-%m-%d') }
      let(:value_for_yesterday) do
        {
          development_cycle: yesterday_development_cycle
        }
      end
      let(:value_for_today) do
        {
          development_cycle: today_development_cycle
        }
      end
      let(:metric_for_yesterday) { Metrics::Base::Metric.new(1, yesterday, value_for_yesterday) }
      let(:metric_for_today) { Metrics::Base::Metric.new(1, today, value_for_today) }
      let(:metrics) { [metric_for_today, metric_for_yesterday] }
      let(:expected_hash_value) do
        {
          formatted_yesterday => yesterday_development_cycle,
          formatted_today => today_development_cycle
        }
      end

      it 'returns the expected hash value' do
        expect(subject.build_data(metrics)).to eq(expected_hash_value)
      end
    end
  end
end
