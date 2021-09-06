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
    whitelisted_pull_request_files.sum do |pull_request_file|
      pull_request_file[:additions]
    end
  end

  def whitelisted_pull_request_files
    pull_request_files.reject do |file|
      ignore_file?(file)
    end
  end

  def ignore_file?(file)
    file_ignoring_rules.any? do |file_ignoring_rule|
      file_ignoring_rule.matches?(file[:filename])
    end
  end

  def pull_request_files
    GithubClient::PullRequest.new(pull_request).files
  end

  def file_ignoring_rules
    @file_ignoring_rules ||= pull_request.repository.language.file_ignoring_rules
  end
end
