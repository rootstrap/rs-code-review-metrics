module Builders
  module Distribution
    module PullRequests
      class PullRequestSizeRepository < BaseService
        def initialize(repository_name:, from:, to:)
          @repository_name = repository_name
          @from = from.to_datetime.beginning_of_day
          @to = to.to_datetime.end_of_day
        end

        def call
          pr_sizes.each_with_object(hash_of_arrays) { |pull_req, hash|
            value = pull_req.size
            interval = Metrics::IntervalResolver::PrSize.call(value)
            pr_values = { html_url: pull_req.html_url, value: value }
            hash[interval] << pr_values
          }.sort.to_h
        end

        private

        def pr_sizes
          @pr_sizes ||= ::Events::PullRequest.where(created_at: @from..@to)
                                             .joins(:repository)
                                             .where(repositories: { name: @repository_name })
                                             .where.not(events_pull_requests: { html_url: nil })
                                             .order(:size)
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
