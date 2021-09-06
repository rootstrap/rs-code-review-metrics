module Builders
  module Chartkick
    module ProjectDistributionDataMetrics
      class MergeTime
        def retrieve_records(entity_id:, time_range:)
          ::MergeTime
            .joins(pull_request: :project)
            .where(projects: { id: entity_id })
            .where(events_pull_requests: { merged_at: time_range })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::Time.call(entity.value_as_hours)
        end
      end
    end
  end
end
