module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_issues
    end

    private

    def update_jira_issues
      JiraProject.find_each do |jira_project|
        JiraProjectDefectEscapeRateUpdater.call(jira_project)
        JiraProjectDevelopmentCycleUpdater.call(jira_project)
      end
    end
  end
end
