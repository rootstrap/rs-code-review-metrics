module Builders
  module Chartkick
    module ProjectDistributionDataMetrics
      class ReviewTurnaround
        def retrieve_records(entity_id:, time_range:)
          ::CompletedReviewTurnaround
            .joins(review_request: :project)
            .where(projects: { id: entity_id })
            .where(created_at: time_range)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end
    end
  end
end
