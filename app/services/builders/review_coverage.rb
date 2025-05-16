module Builders
  class ReviewCoverage < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::ReviewCoverage.create!(
        pull_request: @pull_request,
        total_files_changed: total_files,
        files_with_comments_count: files_with_comments_count
      )
    end

    private

    def total_files
      github_client.files.count
    end

    def files_with_comments_count
      github_client.comments.map { |comment| { filename: comment[:path] } }.uniq.count
    end

    def github_client
      @github_client ||= GithubClient::PullRequest.new(@pull_request)
    end
  end
end
