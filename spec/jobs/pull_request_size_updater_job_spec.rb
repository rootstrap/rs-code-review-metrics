require 'rails_helper'

RSpec.describe PullRequestSizeUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the PullRequestSizeUpdater processor and calls it' do
      expect_any_instance_of(Processors::PullRequestSizeUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
