module JiraBoards
  class NoProjectKeyError < StandardError
    def initialize(jira_project_key)
      @jira_project_key = jira_project_key
    end

    def message
      "Jira key #{@jira_project_key} not found"
    end
  end
end
