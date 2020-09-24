module GithubClient
  class User < GithubClient::Base
    def initialize(username)
      @username = username
    end

    def pull_request_events
      events = (1..10).map do |page|
        response = connection.get("/users/#{@username}/events/public") do |request|
          request.params['page'] = page
        end
        results = JSON.parse(response.body, symbolize_names: true)

        if results.empty? || older_than_a_day(results.last[:created_at]) || results.size < 30
          break results
        end
      end

      events.flatten.select { |pr| pr[:type] == 'PullRequestEvent' }
    end

    def older_than_a_day(created_at)
      DateTime.parse(created_at) < 24.hours.ago
    end
  end
end
