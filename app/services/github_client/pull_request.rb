module GithubClient
  class PullRequest < GithubClient::Repository
    MAX_FILES_PER_PAGE = 100

    def initialize(pull_request)
      super pull_request.repository

      @pull_request = pull_request
    end

    def get
      response = connection.get("repos/#{repository.full_name}/pulls/#{pull_request.number}")
      JSON.parse(response.body).with_indifferent_access
    end

    def files
      url = "repositories/#{repository.github_id}/pulls/#{pull_request.number}/files"
      get_all_paginated_items(url, MAX_FILES_PER_PAGE)
    rescue Faraday::Error => exception
      handle_exception(exception)
      []
    end

    def comments
      url = "repos/#{repository.full_name}/pulls/#{pull_request.number}/comments"
      get_all_paginated_items(url, MAX_FILES_PER_PAGE)
    rescue Faraday::Error => exception
      handle_exception(exception)
      []
    end

    private

    attr_reader :pull_request

    def handle_exception(exception)
      Honeybadger.notify(exception)
      Rails.logger.error(
        "Failed to retrieve data for pull request #{pull_request.number} " \
        "from repository #{repository.full_name}: #{exception.message}"
      )
    end
  end
end
