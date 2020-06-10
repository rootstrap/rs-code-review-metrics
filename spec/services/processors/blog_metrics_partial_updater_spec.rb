require 'rails_helper'

describe Processors::BlogMetricsPartialUpdater do
  describe '.call' do
    it 'calls the BlogTechnologyViewsPartialUpdater processor' do
      expect(Processors::BlogTechnologyViewsPartialUpdater).to receive(:call)

      described_class.call
    end

    it 'calls the BlogPostCountMetricsPartialUpdater processor' do
      expect(Processors::BlogPostCountMetricsPartialUpdater).to receive(:call)

      described_class.call
    end
  end
end
