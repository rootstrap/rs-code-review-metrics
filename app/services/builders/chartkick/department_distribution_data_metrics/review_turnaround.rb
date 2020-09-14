module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class ReviewTurnaround
        def retrieve_records(entity_id:, time_range:)
          ::CompletedReviewTurnaround
            .joins(review_request: { project: { language: :department } })
            .where(departments: { id: entity_id })
            .where(created_at: time_range)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end
    end
  end
end
