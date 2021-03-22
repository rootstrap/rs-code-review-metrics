module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def call
      bugs_to_update.each do |bug|
        bug.deep_symbolize_keys!
        bug_fields = bug[:fields]
        JiraIssue.find_or_create_by!(
          key: bug[:key],
          jira_project: @jira_project,
          informed_at: bug_fields[:created],
          environment: bug_fields[ENV['JIRA_ENVIRONMENT_FIELD'].to_sym][:value],
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
