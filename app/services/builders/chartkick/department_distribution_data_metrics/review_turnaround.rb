module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class ReviewTurnaround
        def records_with_departments
          ::CompletedReviewTurnaround.joins(review_request: { project: { language: :department } })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end
    end
  end
end
