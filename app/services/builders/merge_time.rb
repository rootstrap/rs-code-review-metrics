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
      @pull_request.merged_at.to_i - @pull_request.opened_at.to_i
    end
  end
end
