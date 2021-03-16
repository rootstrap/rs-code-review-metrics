module JiraClient
  class Base
    private

    def connection
      Faraday.new('http://localhost:2990') do |conn|
        conn.basic_auth(ENV['JIRA_ADMIN_USER'], ENV['JIRA_ADMIN_PASSWORD'])
        conn.headers['Content-Type'] = 'application/json'
        conn.response :raise_error
      end
    end
  end
end
