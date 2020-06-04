require 'rails_helper'

RSpec.describe Metrics::PeriodRetriever do
  describe '.call' do
    context 'when daily period' do
      it 'returns query dialy metric class' do
        expect(described_class.call('daily')).to eq(Metrics::Group::Daily)
      end
    end

    context 'when weekly period' do
      it 'returns query dialy metric class' do
        expect(described_class.call('weekly')).to eq(Metrics::Group::Weekly)
      end
    end

    context 'when unsupported period' do
      it 'raise an error' do
        expect { described_class.call('montly') }.to raise_error(Graph::RangeDateNotSupported)
      end
    end
  end
end
