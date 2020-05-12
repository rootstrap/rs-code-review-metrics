require 'rails_helper'

describe BlogPostsFullUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the BlogPostsFullUpdater processor and calls it' do
      expect_any_instance_of(Processors::BlogPostsFullUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
