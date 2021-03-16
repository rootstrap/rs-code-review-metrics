module Builders
  class JiraIssue < BaseService
    def initialize(issue_data)
      @issue_data = issue_data
    end

    def call
      jira_issue = ::JiraIssue.find_or_initialize_by
    end
  end
end
