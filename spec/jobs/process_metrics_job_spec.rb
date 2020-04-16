require 'rails_helper'

RSpec.describe ProcessMetricsJob, type: :job do
  describe '.call' do
    it 'calls review turnaround proccesor' do
      expect_any_instance_of(Processors::ReviewTurnaround).to receive(:call).once

      described_class.perform_now
    end
  end
end
