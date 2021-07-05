require 'rails_helper'

RSpec.describe Builders::Chartkick::DefectEscapeValueData do
  subject { described_class.send(:new, 1, '') }

  describe '.build_data' do
    context 'for a given set of metrics' do
      let(:yesterday) { Date.yesterday }
      let(:formatted_yesterday) { yesterday.strftime('%Y-%m-%d') }
      let(:yesterday_defect_rate) { 100 }
      let(:today) { Time.zone.today }
      let(:today_defect_rate) { 50 }
      let(:formatted_today) { today.strftime('%Y-%m-%d') }
      let(:value_for_yesterday) do
        {
          defect_rate: yesterday_defect_rate,
          bugs_by_environment: { 'staging' => 1 }
        }
      end
      let(:value_for_today) do
        {
          defect_rate: today_defect_rate,
          bugs_by_environment: { 'development' => 1, 'staging' => 1 }
        }
      end
      let(:metric_for_yesterday) { Metrics::Base::Metric.new(1, yesterday, value_for_yesterday) }
      let(:metric_for_today) { Metrics::Base::Metric.new(1, today, value_for_today) }
      let(:metrics) { [metric_for_today, metric_for_yesterday] }
      let(:expected_hash_value) do
        {
          rate: 66,
          total: 3,
          values: { 'development' => 1, 'staging' => 2 }
        }
      end

      it 'returns the expected hash value' do
        expect(subject.build_data(metrics)).to eq(expected_hash_value)
      end
    end
  end
end
