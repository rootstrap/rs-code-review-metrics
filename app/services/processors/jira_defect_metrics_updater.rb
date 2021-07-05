module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_bugs
    end

    private

    def update_jira_bugs
      JiraProject.find_each do |jira_project|
        JiraProjectDefectEscapeRateUpdater.call(jira_project)
      end
    end
  end
end
