require 'rails_helper'

describe BlogPostsUpdaterJob do
  describe '#perform' do
    it 'calls the BlogPostsUpdater processor' do
      expect_any_instance_of(Processors::BlogPostsUpdater).to receive(:call).once

      described_class.perform_now
    end
  end
end