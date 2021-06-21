module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def call
      bugs_to_update.each do |bug|
        bug.deep_symbolize_keys!
        bug_fields = bug[:fields]
        environment_field = bug_fields[ENV['JIRA_ENVIRONMENT_FIELD'].to_sym]

        issue = JiraIssue.find_or_initialize_by(
          key: bug[:key],
          jira_project_id: @jira_project.id
        )

        issue.update!(
          informed_at: bug_fields[:created],
          environment: environment_field ? environment_field[:value] : nil,
          issue_type: 'bug'
        )
      end
    end

    private

    def bugs_to_update
      JiraClient::Repository.new(@jira_project).bugs
    end
  end
end
