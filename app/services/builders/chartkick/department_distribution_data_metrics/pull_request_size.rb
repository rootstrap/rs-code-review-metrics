module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class PullRequestSize
        def records_with_departments
          ::PullRequestSize.joins(pull_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PrSize.call(entity.value)
        end
      end
    end
  end
end
