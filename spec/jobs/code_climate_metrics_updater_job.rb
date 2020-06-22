require 'rails_helper'

describe CodeClimateMetricsUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the BlogMetricsFullUpdater processor and calls it' do
      expect_any_instance_of(Processors::BlogMetricsFullUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
