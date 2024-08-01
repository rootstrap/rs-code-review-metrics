module GithubClient
  class User < GithubClient::Base
    PAGE_SIZE = 30

    def initialize(username)
      @username = username
    end

    def pull_request_events
      events = retrieve_events

      events.flatten.select { |event| event[:type] == 'PullRequestEvent' }
    rescue URI::InvalidURIError => exception
      Honeybadger.notify(exception)
      Rails.logger.error(exception)
    end

    private

    def older_than(created_at)
      DateTime.parse(created_at) < ENV.fetch('SCHEDULE_EXTERNAL_PULL_REQUESTS', 2).to_i.days.ago
    end

    def retrieve_events
      (1..10).each_with_object([]) do |page, collected_results|
        response = connection.get("/users/#{@username}/events/public") do |request|
          request.params['page'] = page
        end

        results = JSON.parse(response.body, symbolize_names: true)
        collected_results << results

        if results.empty? || older_than(results.last[:created_at]) || results.size < PAGE_SIZE
          break collected_results
        end
      end
    rescue Faraday::ResourceNotFound => exception
      Honeybadger.notify(exception)
      Rails.logger.error(exception)
    end
  end
end
