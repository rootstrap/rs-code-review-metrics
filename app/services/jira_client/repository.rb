module JiraClient
  class Repository < JiraClient::Base
    def initialize(jira_project)
      @jira_project = jira_project
    end

    def bugs
      create_request('issuetype=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    def issues
      create_request('issuetype!=Bug')

      JSON.parse(fetch_response.body)['issues'].map(&:deep_symbolize_keys)
    rescue Faraday::ForbiddenError => exception
      ExceptionHunter.track(exception)
    end

    private

    def create_request(issue_type)
      @request_params = {
        jql: "project=#{@jira_project.jira_project_key} AND #{issue_type}",
        fields: "#{ENV['JIRA_ENVIRONMENT_FIELD']},created"
      }
    end

    def fetch_response
      connection.get('search') do |request|
        request.params = @request_params
      end
    end
  end
end
