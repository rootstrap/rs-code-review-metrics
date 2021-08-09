module JiraClient
  class Repository < JiraClient::Base
    JIRA_ENVIRONMENT_FIELD = ENV['JIRA_ENVIRONMENT_FIELD']

    def initialize(product)
      @product = product
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
        jql: "project=#{@product.jira_project_key} AND #{issue_type}",
        fields: "#{JIRA_ENVIRONMENT_FIELD},created"
      }
    end

    def fetch_response
      connection.get('search') do |request|
        request.params = @request_params
      end
    end
  end
end
