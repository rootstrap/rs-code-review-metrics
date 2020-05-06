require 'rails_helper'

RSpec.describe Processors::ReviewTurnaround do
  describe '.call' do
    context 'when the processing weekly metrics' do
      it 'calls the review turnaround processor with a weekly interval' do
        expect_any_instance_of(Metrics::Weekly::ReviewTurnaround::PerUserProject).to receive(:call)
        described_class.call('weekly')
      end
    end

    context 'when the processing daily metrics' do
      it 'calls the review turnaround processor with a weekly interval' do
        expect_any_instance_of(Metrics::Daily::ReviewTurnaround::PerUserProject).to receive(:call)
        described_class.call('daily')
      end
    end
  end
end
