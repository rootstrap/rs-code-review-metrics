module Builders
  class MergeTime < ::DistributionInterval
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      ::MergeTime.create!(pull_request: @pull_request, value: calculate_merge_time)
    end

    private

    def calculate_merge_time
      seconds_interval = merged_pr.to_i - @pull_request.opened_at.to_i
      seconds_interval - weekend_days_as_seconds(
        @pull_request.opened_at.to_date..@pull_request.merged_at.to_date
      )
    end

    def merged_pr
      @merged_pr = if @pull_request.merged_on_weekend?
                     @pull_request.merged_at.end_of_day
                   else
                     @pull_request.merged_at
                   end
    end
  end
end
