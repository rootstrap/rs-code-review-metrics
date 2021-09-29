require 'rails_helper'

describe AdminSendAlertsJob do
  describe '#perform' do
    it 'correctly initializes the AdminSendAlerts processor and calls it' do
      expect_any_instance_of(AlertsService)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
