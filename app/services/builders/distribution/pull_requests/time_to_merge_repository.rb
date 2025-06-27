module Builders
  module Distribution
    module PullRequests
      class TimeToMergeRepository < BaseService
        def initialize(repository_name:, from:, to:, base_branch: nil)
          @repository_name = repository_name
          @from = from.to_datetime.beginning_of_day
          @to = to.to_datetime.end_of_day
          @base_branch = base_branch
        end

        def call
          merge_times.each_with_object(hash_of_arrays) { |merge_time, hash|
            value_as_hours = merge_time.value_as_hours
            interval = Metrics::IntervalResolver::Time.call(value_as_hours)
            pr_values = { html_url: merge_time.pull_request.html_url, value: value_as_hours }
            hash[interval] << pr_values
          }.sort.to_h
        end

        private

        def merge_times
          @merge_times ||= build_merge_times_query
        end

        def build_merge_times_query
          query = ::MergeTime.where(created_at: @from..@to)
                             .joins(pull_request: :repository)
                             .where(repositories: { name: @repository_name })
                             .where.not(events_pull_requests: { html_url: nil })
                             .where.not(
                               events_pull_requests: { owner: User.ignored_users }
                             )
                             .includes(:pull_request)
                             .order(:value)

          if @base_branch.present?
            query = query.where(events_pull_requests: { base_branch: @base_branch })
          end
          query
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
