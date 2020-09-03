require 'rails_helper'

RSpec.describe Metrics::IntervalResolver do
  class ExampleIntervalResolver < Metrics::IntervalResolver
    def ranges
      { '1-49': 50, '50-99': 100, '100-199': 200 }
    end
  end

  describe '.call' do
    subject(:interval) { ExampleIntervalResolver.call(value) }

    context 'when the value matches one of the intervals' do
      let(:value) { 72 }

      it 'returns that interval' do
        expect(interval).to eq('50-99')
      end
    end

    context 'when the value is bigger than all the intervals' do
      let(:value) { 200 }

      it 'returns the upper limit of the ranges with a "+" beside it' do
        expect(interval).to eq('200+')
      end
    end
  end

  describe Metrics::IntervalResolver::Time do
    describe '.call' do
      context 'when the value is less than 12 hours' do
        let(:value_as_hours) { 10 }

        it 'returns 1-12 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('1-12')
        end
      end

      context 'when the value is less than 24 hours' do
        let(:value_as_hours) { 20 }

        it 'returns 12-24 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('12-24')
        end
      end

      context 'when the value is less than 36 hours' do
        let(:value_as_hours) { 26 }

        it 'returns 24-36 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('24-36')
        end
      end

      context 'when the value is less than 48 hours' do
        let(:value_as_hours) { 42 }

        it 'returns 36-48 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('36-48')
        end
      end

      context 'when the value is less than 60 hours' do
        let(:value_as_hours) { 56 }

        it 'returns 48-60 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('48-60')
        end
      end

      context 'when the value is less than 72 hours' do
        let(:value_as_hours) { 62 }

        it 'returns 60-72 interval as value' do
          expect(described_class.call(value_as_hours)).to eq('60-72')
        end
      end

      context 'when the value is greater than 72 hours' do
        let(:value_as_hours) { 80 }

        it 'returns 72+ interval as value' do
          expect(described_class.call(value_as_hours)).to eq('72+')
        end
      end
    end
  end
end
