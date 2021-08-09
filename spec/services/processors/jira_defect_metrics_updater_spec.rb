require 'rails_helper'

describe Processors::JiraDefectMetricsUpdater do
  describe '#call' do
    let!(:first_product) { create :product }
    let!(:second_product) { create :product }
    let(:subject) { described_class.call }

    it('calls jira metrics processors on each jira project') do
      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(first_product)
      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(second_product)

      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(first_product)
      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(second_product)

      subject
    end
  end
end
