require 'rails_helper'

RSpec.describe ProcessReviewTurnaroundMetricsJob, type: :job do
  describe '.perform' do
    it 'calls review turnaround proccesor' do
      expect_any_instance_of(Processors::ReviewTurnaround).to receive(:call).once

      described_class.perform_now
    end
  end
end
