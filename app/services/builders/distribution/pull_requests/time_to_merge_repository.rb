module Builders
  module Distribution
    module PullRequests
      class TimeToMergeRepository < BaseService
        def initialize(repository_name:, from:)
          @repository_name = repository_name
          @from = from.to_i
        end

        def call
          merge_times.each_with_object(hash_of_arrays) { |merge_time, hash|
            interval = Metrics::IntervalResolver::Time.call(merge_time.value_as_hours)
            hash[interval] << merge_time.pull_request.html_url
          }.sort.to_h
        end

        private

        def merge_times
          @merge_times ||= ::MergeTime.where(created_at: @from.weeks.ago..Time.zone.now)
                                      .joins(pull_request: :repository)
                                      .where(repositories: { name: @repository_name })
                                      .where.not(events_pull_requests: { html_url: nil })
                                      .includes(:pull_request)
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
