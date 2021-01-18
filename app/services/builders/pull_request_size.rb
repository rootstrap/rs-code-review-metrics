module Builders
  class PullRequestSize < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      value = PullRequestSizeCalculator.call(pull_request)
      pull_request.update!(size: value)
    rescue Faraday::Error => exception
      track_request_error(exception)
    end

    private

    attr_reader :pull_request
  end
end
