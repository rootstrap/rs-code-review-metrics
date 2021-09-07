module GithubClient
  class Repository < GithubClient::Base
    LOCATIONS = %w[.github/CODEOWNERS docs/CODEOWNERS CODEOWNERS].freeze

    def initialize(repository)
      @repository = repository
    end

    def code_owners
      find_in_locations
    end

    def pull_requests
      response = connection.get("repositories/#{@repository.github_id}/pulls") do |request|
        request['state'] = 'all'
      end
      JSON.parse(response.body, symbolize_names: true)
    end

    def views
      response = connection.get("repositories/#{repository.github_id}/traffic/views") do |request|
        request.params['per'] = 'week'
      end
      JSON.parse(response.body).with_indifferent_access
    end

    private

    attr_reader :repository

    def find_in_locations
      LOCATIONS.each do |location|
        url = "repos/rootstrap/#{repository.name}/contents/#{location}"
        response = connection.get(url) do |request|
          request.headers['Accept'] = 'application/vnd.github.v3.raw'
        end

        return response.body
      rescue Faraday::ResourceNotFound
        next
      end
      ''
    end
  end
end
