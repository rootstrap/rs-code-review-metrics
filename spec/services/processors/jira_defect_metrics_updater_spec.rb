require 'rails_helper'

describe Processors::JiraDefectMetricsUpdater do
  describe '#call' do
    let!(:first_project) { create :jira_project }
    let!(:second_project) { create :jira_project }
    let(:subject) { described_class.call }

    it('calls jira metrics processors on each jira project') do
      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(first_project)
      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(second_project)

      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(first_project)
      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(second_project)

      subject
    end
  end
end
