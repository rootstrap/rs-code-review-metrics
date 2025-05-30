module Builders
  module Chartkick
    module RepositoryDistributionDataMetrics
      class MergeTime
        def retrieve_records(entity_id:, time_range:)
          ::MergeTime
            .joins(pull_request: :repository)
            .where(repositories: { id: entity_id })
            .where(events_pull_requests: { merged_at: time_range })
            .where.not(events_pull_requests: { owner: User.ignored_users })
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
