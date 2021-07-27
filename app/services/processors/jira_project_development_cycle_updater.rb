module Processors
  class JiraProjectDevelopmentCycleUpdater < BaseService
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def call
      issues_to_update.each do |issue|
        issue.deep_symbolize_keys!
        issue_fields = issue[:fields]

        issue = JiraIssue.find_or_initialize_by(
          key: issue[:key],
          jira_project_id: @jira_project.id
        )

        issue_update!(issue, issue_fields)

        if issue.resolved_at.present?
          JiraClient::JiraIssueService.new(@jira_project, issue).generate_development_cycle_metric
        end
      end
    end

    private

    def issues_to_update
      JiraClient::Repository.new(@jira_project).issues
    end

    def issue_update!(issue, issue_fields)
      environment_field = issue_fields[ENV['JIRA_ENVIRONMENT_FIELD'].to_sym]
      issue_type_field = issue_fields[:issuetype.to_sym][:name]

      issue.update!(
        informed_at: issue_fields[:created],
        resolved_at: issue_fields[:resolutiondate] || nil,
        environment: environment_field ? environment_field.first[:value]&.downcase : nil,
        issue_type: issue_type_field&.downcase
      )
    end
  end
end
