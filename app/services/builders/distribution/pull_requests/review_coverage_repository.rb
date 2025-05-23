module Builders
  module Distribution
    module PullRequests
      class ReviewCoverageRepository < BaseService
        def initialize(repository_name:, from:, to:)
          @repository_name = repository_name
          @from = from.to_datetime.beginning_of_day
          @to = to.to_datetime.end_of_day
        end

        def call
          review_coverages.each_with_object(hash_of_arrays) { |review_coverage, hash|
            coverage = review_coverage.coverage_percentage * 100
            interval = Metrics::IntervalResolver::Percentage.call(coverage)
            pr_values = { html_url: review_coverage.pull_request.html_url, value: coverage }
            hash[interval] << pr_values
          }.sort.to_h
        end

        private

        def review_coverages
          @review_coverages ||= ::ReviewCoverage
                                .joins(pull_request: :repository)
                                .where(repositories: { name: @repository_name })
                                .where(pull_request: { merged_at: @from..@to })
                                .where.not(pull_request: { owner: User.ignored_users })
                                .order(:coverage_percentage)
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
