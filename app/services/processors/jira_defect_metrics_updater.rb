module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_defect_escape_ratio
    end

    private

    def update_defect_metrics
      JiraDefectEscapeRatioUpdater.call
    end
  end
end
