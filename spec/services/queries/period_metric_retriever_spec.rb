require 'rails_helper'

RSpec.describe Queries::PeriodMetricRetriever do
  describe '#call' do
    context 'when daily period' do
      it 'returns query dialy metric class' do
        expect(described_class.call('daily')).to eq(Queries::DailyMetrics)
      end
    end

    context 'when weekly period' do
      it 'returns query dialy metric class' do
        expect(described_class.call('weekly')).to eq(Queries::WeeklyMetrics)
      end
    end

    context 'when unsupported period' do
      it 'raise an error' do
        expect { described_class.call('montly') }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
