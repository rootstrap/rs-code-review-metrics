module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class ReviewCoverage
        def retrieve_records(entity_id:, time_range:)
          ::ReviewCoverage
            .joins(pull_request: :repository)
            .where(repositories: { id: entity_id })
            .where(events_pull_requests: { merged_at: time_range })
            .where.not(events_pull_requests: { owner: User.ignored_users })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Percentage.call(entity.coverage_percentage * 100)
        end

        def value_for_average(entity)
          entity.coverage_percentage * 100
        end
      end
    end
  end
end
