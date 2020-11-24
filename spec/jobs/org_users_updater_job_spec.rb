require 'rails_helper'

describe OrgUsersUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the OrgUsersUpdater processor and calls it' do
      expect_any_instance_of(Processors::OrgUsersUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
