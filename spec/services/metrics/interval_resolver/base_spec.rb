require 'rails_helper'

RSpec.describe Metrics::IntervalResolver do
  class ExampleIntervalResolver < Metrics::IntervalResolver::Base
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
end
