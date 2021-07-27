module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def call
      bugs_to_update.each do |bug|
        bug.deep_symbolize_keys!
        bug_fields = bug[:fields]

        issue = JiraIssue.find_or_initialize_by(
          key: bug[:key],
          jira_project_id: @jira_project.id
        )

        issue_update!(issue, bug_fields)

        if issue.resolved_at.present?
          JiraClient::JiraIssueService.new(@jira_project, issue).generate_development_cycle_metric
        end
      end
    end

    private

    def bugs_to_update
      JiraClient::Repository.new(@jira_project).bugs
    end

    def issue_update!(issue, bug_fields)
      environment_field = bug_fields[ENV['JIRA_ENVIRONMENT_FIELD'].to_sym]

      issue.update!(
        informed_at: bug_fields[:created],
        resolved_at: bug_fields[:resolutiondate] || nil,
        environment: environment_field ? environment_field.first[:value].downcase : nil,
        issue_type: 'bug'
      )
    end
  end
end
