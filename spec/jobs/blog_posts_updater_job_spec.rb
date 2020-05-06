require 'rails_helper'

describe BlogPostsUpdaterJob do
  describe '#perform' do
    let(:full_update?) { true }

    it 'correctly initializes the BlogPostsUpdater processor and calls it' do
      expect(Processors::BlogPostsUpdater)
        .to receive(:new)
        .with(full_update: full_update?)
        .and_call_original

      expect_any_instance_of(Processors::BlogPostsUpdater)
        .to receive(:call)
        .once

      described_class.perform_now(full_update?)
    end
  end
end
