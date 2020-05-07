require 'rails_helper'

describe BlogPostsPartialUpdaterJob do
  describe '#perform' do
    it 'correctly initializes the BlogPostsPartialUpdater processor and calls it' do
      expect_any_instance_of(Processors::BlogPostsPartialUpdater)
        .to receive(:call)
        .once

      described_class.perform_now
    end
  end
end
