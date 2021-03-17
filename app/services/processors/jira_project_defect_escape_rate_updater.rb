module Processors
  class JiraProjectDefectEscapeRateUpdater < BaseService
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def call
      bugs_to_update.each do |bug|
        JiraIssue.find_or_create_by!(
          key: bug['key'],
          jira_project: jira_project,
          informed_at: bug['fields']['created'],
          environment: bug['fields'][ENV['JIRA_ENVIRONMENT_FIELD']]['value'],
          issue_type: 'bug'
        )
      end
    end

    private

    def bugs_to_update
      JiraClient::Repository.new(jira_project).bugs
    end
  end
end
