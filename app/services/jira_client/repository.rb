module JiraClient
  class Repository < JiraClient::Base
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def bugs
      request_params = {
        jql: "project=#{@jira_project.jira_project_key} AND issuetype=Bug",
        fields: "#{ENV['JIRA_ENVIRONMENT_FIELD']},created"
      }
      response = connection.get('search') do |request|
        request.params = request_params
      end

      JSON.parse(response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    def issues
      request_params = {
        jql: "project=#{@jira_project.jira_project_key} AND issuetype!=Bug",
        fields: "#{ENV['JIRA_ENVIRONMENT_FIELD']},created"
      }
      response = connection.get('search') do |request|
        request.params = request_params
      end

      JSON.parse(response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end
  end
end
