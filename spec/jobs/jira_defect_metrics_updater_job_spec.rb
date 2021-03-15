require 'rails_helper'

describe JiraDefectMetricsUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the JiraDefectMetricsUpdater processor and calls it' do
      expect_any_instance_of(Processors::JiraDefectMetricsUpdater)
        .to receive(:call)
              .once

      described_class.perform_now
    end
  end
end
