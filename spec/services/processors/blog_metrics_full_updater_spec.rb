require 'rails_helper'

describe Processors::BlogMetricsFullUpdater do
  describe '.call' do
    it 'calls the BlogTechnologyViewsFullUpdater processor' do
      expect(Processors::BlogTechnologyViewsFullUpdater).to receive(:call)

      described_class.call
    end

    it 'calls the BlogPostCountMetricsFullUpdater processor' do
      expect(Processors::BlogPostCountMetricsFullUpdater).to receive(:call)

      described_class.call
    end
  end
end
