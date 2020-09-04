module GithubClient
  class Repository < GithubClient::Base
    LOCATIONS = %w[.github/CODEOWNERS docs/CODEOWNERS CODEOWNERS].freeze

    def initialize(project)
      @project = project
    end

    def code_owners
      find_in_locations
    end

    def pull_requests
      response = connection.get("repositories/#{@project.github_id}/pulls") do |request|
        request['state'] = 'all'
      end
      response_body = response.body
      JSON.parse(response_body, symbolize_names: true) unless response_body.empty?
    end

    def views
      response = connection.get("repositories/#{@project.github_id}/traffic/views") do |request|
        request.params['per'] = 'week'
      end
      JSON.parse(response.body).with_indifferent_access
    end

    private

    def find_in_locations
      LOCATIONS.each do |location|
        url = "repos/rootstrap/#{@project.name}/contents/#{location}"
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
