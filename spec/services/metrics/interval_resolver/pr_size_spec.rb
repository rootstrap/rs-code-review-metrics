require 'rails_helper'

RSpec.describe Metrics::IntervalResolver::PrSize do
  describe '.call' do
    context 'when the value is between 1 and 100' do
      let(:value) { 10 }

      it 'returns 1-99 interval as value' do
        expect(described_class.call(value)).to eq('1-99')
      end
    end

    context 'when the value is between 100 and 200' do
      let(:value) { 100 }

      it 'returns 100-199 interval as value' do
        expect(described_class.call(value)).to eq('100-199')
      end
    end

    context 'when the value is between 200 and 300' do
      let(:value) { 299 }

      it 'returns 200-299 interval as value' do
        expect(described_class.call(value)).to eq('200-299')
      end
    end

    context 'when the value is between 300 and 400' do
      let(:value) { 345 }

      it 'returns 300-399 interval as value' do
        expect(described_class.call(value)).to eq('300-399')
      end
    end

    context 'when the value is between 400 and 500' do
      let(:value) { 444 }

      it 'returns 400-499 interval as value' do
        expect(described_class.call(value)).to eq('400-499')
      end
    end

    context 'when the value is between 500 and 600' do
      let(:value) { 550 }

      it 'returns 500-599 interval as value' do
        expect(described_class.call(value)).to eq('500-599')
      end
    end

    context 'when the value is between 600 and 700' do
      let(:value) { 627 }

      it 'returns 600-699 interval as value' do
        expect(described_class.call(value)).to eq('600-699')
      end
    end

    context 'when the value is between 700 and 800' do
      let(:value) { 768 }

      it 'returns 700-799 interval as value' do
        expect(described_class.call(value)).to eq('700-799')
      end
    end

    context 'when the value is between 800 and 900' do
      let(:value) { 806 }

      it 'returns 800-899 interval as value' do
        expect(described_class.call(value)).to eq('800-899')
      end
    end

    context 'when the value is between 900 and 1000' do
      let(:value) { 999 }

      it 'returns 900-999 interval as value' do
        expect(described_class.call(value)).to eq('900-999')
      end
    end

    context 'when the value is greater than or equal to than 1000' do
      let(:value_as_hours) { 1000 }

      it 'returns 1000+ interval as value' do
        expect(described_class.call(value_as_hours)).to eq('1000+')
      end
    end
  end
end
