module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class MergeTime
        def records_with_departments
          ::MergeTime.joins(pull_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end
    end
  end
end
