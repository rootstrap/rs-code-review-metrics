require 'rails_helper'

describe OpenSourceMetricsUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the OpenSourceMetricsUpdater processor and calls it' do
      expect_any_instance_of(Processors::OpenSourceMetricsUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
