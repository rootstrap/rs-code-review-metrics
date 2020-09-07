class PullRequestSizeCalculator < BaseService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    pull_request_additions
  end

  private

  attr_reader :pull_request

  def pull_request_additions
    pull_request_files.sum do |pull_request_file|
      pull_request_file[:additions]
    end
  end

  def pull_request_files
    GithubClient::PullRequest.new(pull_request).files
  end
end
