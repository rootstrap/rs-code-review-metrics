module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_bugs
    end

    private

    def update_jira_bugs
      JiraProject.each do |jira_project|
        JiraProjectDefectEscapeRateUpdater.new(jira_project).call
      end
    end
  end
end
