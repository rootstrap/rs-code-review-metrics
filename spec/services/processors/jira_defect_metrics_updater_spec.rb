require 'rails_helper'

describe Processors::JiraDefectMetricsUpdater do
  describe '#call' do
    let!(:first_board) { create :jira_board }
    let!(:second_board) { create :jira_board }
    let(:subject) { described_class.call }

    it('calls jira metrics processors on each jira project') do
      expect(Processors::JiraProjectBoardUpdater).to receive(:call).once
                                                                   .with(first_board)
      expect(Processors::JiraProjectBoardUpdater).to receive(:call).once
                                                                   .with(second_board)

      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(first_board)
      expect(Processors::JiraProjectDefectEscapeRateUpdater).to receive(:call).once
                                                                              .with(second_board)

      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(first_board)
      expect(Processors::JiraProjectDevelopmentCycleUpdater).to receive(:call).once
                                                                              .with(second_board)

      expect(Processors::JiraProjectPlannedToDoneUpdater).to receive(:call).once
                                                                           .with(first_board)
      expect(Processors::JiraProjectPlannedToDoneUpdater).to receive(:call).once
                                                                           .with(second_board)
      subject
    end
  end
end
