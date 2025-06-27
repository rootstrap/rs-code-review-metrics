module Builders
  module Distribution
    module PullRequests
      class ReviewCoverageRepository < BaseService
        def initialize(repository_name:, from:, to:, base_branch: nil)
          @repository_name = repository_name
          @from = from.to_datetime.beginning_of_day
          @to = to.to_datetime.end_of_day
          @base_branch = base_branch
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
          @review_coverages ||= build_review_coverages_query
        end

        def build_review_coverages_query
          query = ::ReviewCoverage
                  .joins(pull_request: :repository)
                  .where(repositories: { name: @repository_name })
                  .where(pull_request: { merged_at: @from..@to })
                  .where.not(pull_request: { owner: User.ignored_users })
                  .order(:coverage_percentage)

          query = query.where(pull_request: { base_branch: @base_branch }) if @base_branch.present?
          query
        end

        def hash_of_arrays
          Hash.new { |hash, key| hash[key] = [] }
        end
      end
    end
  end
end
