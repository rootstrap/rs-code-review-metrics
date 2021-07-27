module JiraClient
  class JiraIssueService
    def initialize(jira_project, jira_issue)
      @jira_project = jira_project
      @jira_issue = jira_issue
    end

    def generate_development_cycle_metric
      Metric.create(
        name: Metric.names[:development_cycle],
        interval: Metric.intervals[:weekly],
        ownable: @jira_project.product,
        value: @jira_issue.resolved_at - @jira_issue.informed_at,
        value_timestamp: Time.current
      )
    end
  end
end
