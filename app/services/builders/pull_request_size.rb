module Builders
  class PullRequestSize < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      update_or_create_pull_request_size
    rescue Faraday::Error => exception
      ExceptionHunter.track(exception)
    end

    private

    attr_reader :pull_request

    def update_or_create_pull_request_size
      create_pull_request_size || update_pull_request_size
    end

    def create_pull_request_size
      ::PullRequestSize.create!(pull_request: pull_request, value: pull_request_size_value)
    rescue ::ActiveRecord::RecordNotUnique
      nil
    rescue ::ActiveRecord::RecordInvalid => exception
      if exception.message != 'Validation failed: Pull request has already been taken'
        raise exception
      end

      nil
    end

    def update_pull_request_size
      ::PullRequestSize.find_by!(pull_request: pull_request).tap do |pull_request_size|
        pull_request_size.value = pull_request_size_value
        pull_request_size.save!
      end
    end

    def pull_request_size_value
      @pull_request_size_value ||= calculate_pull_request_size
    end

    def calculate_pull_request_size
      PullRequestSizeCalculator.call(pull_request)
    end
  end
end
