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
    end

    private

    attr_reader :pull_request
  end
end
