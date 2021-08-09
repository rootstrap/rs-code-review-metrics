module Processors
  class JiraDefectMetricsUpdater < BaseService
    def call
      update_jira_issues
    end

    private

    def update_jira_issues
      Product.find_each do |product|
        JiraProjectDefectEscapeRateUpdater.call(product)
        JiraProjectDevelopmentCycleUpdater.call(product)
      end
    end
  end
end
