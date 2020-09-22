module Builders
  class PullRequestSize < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::PullRequestSize.find_or_initialize_by(pull_request: pull_request).tap do |pull_request_size|
        pull_request_size.value = calculate_size
        pull_request_size.save!
      end
    rescue Faraday::Error => exception
      ExceptionHunter.track(exception)
    end

    private

    attr_reader :pull_request

    def calculate_size
      PullRequestSizeCalculator.call(pull_request)
    end
  end
end
