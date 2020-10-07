module GithubClient
  class User < GithubClient::Base
    PAGE_SIZE = 30

    def initialize(username)
      @username = username
    end

    def pull_request_events
      events = retrieve_events

      events.select { |event| event[:type] == 'PullRequestEvent' }
    rescue URI::InvalidURIError => exception
      ExceptionHunter.track(exception)
      []
    end

    private

    def older_than(created_at)
      DateTime.parse(created_at) < ENV.fetch('SCHEDULE_EXTERNAL_PULL_REQUESTS', 1).to_i.days.ago
    end

    def retrieve_events
      (1..10).flat_map do |page|
        response = connection.get("/users/#{@username}/events/public") do |request|
          request.params['page'] = page
        end

        results = JSON.parse(response.body, symbolize_names: true)

        if results.empty? || older_than(results.last[:created_at]) || results.size < PAGE_SIZE
          break results
        end

        results
      end
    end
  end
end
