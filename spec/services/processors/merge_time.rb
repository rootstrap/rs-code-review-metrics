require 'rails_helper'

RSpec.describe Processors::MergeTime do
  describe '#call' do
    it 'executes all the metrics processors defined' do
      described_class::ENTITIES.each do |entity|
        expect_any_instance_of(Metrics::MergeTime.const_get("Per#{entity}"))
          .to receive(:call)
      end
    end
  end
end
