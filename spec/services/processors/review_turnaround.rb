require 'rails_helper'

RSpec.describe Processors::ReviewTurnaround do
  describe '.call' do
    it 'executes all the metrics processors defined' do
      described_class::ENTITIES.each do |entity|
        expect_any_instance_of(Metrics::ReviewTurnaround.const_get("Per#{entity}"))
          .to receive(:call)
      end
    end
  end
end
