module GithubClient
  class PullRequest < GithubClient::Repository
    MAX_FILES_PER_PAGE = 100

    def initialize(project, pull_request)
      super project

      @pull_request = pull_request
    end

    def files
      url = "repositories/#{project.github_id}/pulls/#{pull_request.number}/files"
      get_all_paginated_items(url, MAX_FILES_PER_PAGE)
    end

    private

    attr_reader :pull_request
  end
end
