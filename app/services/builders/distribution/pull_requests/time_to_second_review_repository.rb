module Builders
  module Distribution
    module PullRequests
      class TimeToSecondReviewRepository < BaseService
        def initialize(repository_name:, from:, to:)
          @repository_name = repository_name
          @from = from.to_datetime.beginning_of_day
          @to = to.to_datetime.end_of_day
        end

        def call
          completed_rt.each_with_object(hash_of_arrays) { |completed_rt, hash|
            interval = Metrics::IntervalResolver::Time.call(completed_rt.value_as_hours)
            hash[interval] << completed_rt.review_request.pull_request.html_url
          }.sort.to_h
        end

        private

        def completed_rt
          @completed_rt ||= begin
            ::CompletedReviewTurnaround.where(created_at: @from..@to)
                                       .joins(review_request:
                                         { pull_request: :repository })
                                       .where(repositories: { name: @repository_name })
                                       .where.not(events_pull_requests: { html_url: nil })
                                       .includes(review_request: :pull_request)
          end
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
