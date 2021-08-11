module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_issues
    end

    private

    def update_jira_issues
      JiraBoard.find_each do |jira_board|
        JiraProjectDefectEscapeRateUpdater.call(jira_board)
        JiraProjectDevelopmentCycleUpdater.call(jira_board)
      end
    end
  end
end
