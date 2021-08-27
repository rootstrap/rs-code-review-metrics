module JiraClient
  class Base
    private

    def connection(path)
      Faraday.new(path) do |conn|
        conn.basic_auth(ENV.fetch('JIRA_ADMIN_USER'), ENV.fetch('JIRA_ADMIN_TOKEN'))
        conn.headers['Content-Type'] = 'application/json'
        conn.response :raise_error
      end
    end

    def root_connection
      connection(ENV['JIRA_ROOT_URL'])
    end

    def agile_connection
      connection(ENV['JIRA_AGILE_URL'])
    end

    def reports_connection
      connection(ENV['JIRA_REPORTS_URL'])
    end
  end
end
