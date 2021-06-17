module JiraClient
  class Base
    private

    def connection
      Faraday.new(ENV['JIRA_ROOT_URL']) do |conn|
        conn.basic_auth(ENV.fetch('JIRA_ADMIN_USER'), ENV.fetch('JIRA_ADMIN_PASSWORD'))
        conn.headers['Content-Type'] = 'application/json'
        conn.response :raise_error
      end
    end
  end
end
