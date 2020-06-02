require 'rails_helper'

describe BlogMetricsPartialUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the BlogMetricsPartialUpdater processor and calls it' do
      expect_any_instance_of(Processors::BlogMetricsPartialUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
