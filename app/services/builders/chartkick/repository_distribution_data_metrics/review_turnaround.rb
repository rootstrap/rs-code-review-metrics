module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class ReviewTurnaround
        def retrieve_records(entity_id:, time_range:, base_branch: nil)
          query = ::CompletedReviewTurnaround
                  .joins(review_request: :repository)
                  .joins(:pull_request)
                  .where(repositories: { id: entity_id })
                  .where(created_at: time_range)

          if base_branch.present?
            query = query.where(events_pull_requests: { base_branch: base_branch })
          end
          query
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end

        def value_for_average(entity)
          entity.value_as_hours
        end
      end
    end
  end
end
