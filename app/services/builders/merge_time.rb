module Builders
  class MergeTime < BaseService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::MergeTime.create!(pull_request: @pull_request, value: calculate_merge_time)
    end

    private

    def calculate_merge_time
      weekend_seconds = WeekendSecondsInterval.call(
        start_date: pull_request_opened_at, end_date: pull_request_merged_at
      )
      (pull_request_merged_at.to_i - pull_request_opened_at.to_i) - weekend_seconds
    end

    def pull_request_opened_at
      @pull_request_opened_at ||= @pull_request.opened_at
    end

    def pull_request_merged_at
      @pull_request_merged_at ||= @pull_request.merged_at
    end
  end
end
