module JiraClient
  class Repository < JiraClient::Base
    attr_reader :project

    def bugs
      response = connection.get("/jira/rest/api/2/search?jql=issueType=Bug&fields=#{ENV['JIRA_ENVIRONMENT_FIELD']},created,project")
      JSON.parse(response.body).deep_symbolize_keys[:issues]
    rescue Faraday::ForbiddenError => error
        ExceptionHunter.track(error)
    end
  end
end
