module Builders
  class PullRequestSize < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::PullRequestSize.find_or_initialize_by(pull_request: pull_request).tap do |pr_size|
        pr_size.value = calculate_size
        pr_size.save!
      end
    rescue Faraday::Error => exception
      track_request_error(exception)
    end

    private

    attr_reader :pull_request

    def calculate_size
      PullRequestSizeCalculator.call(pull_request)
    end
  end
end
