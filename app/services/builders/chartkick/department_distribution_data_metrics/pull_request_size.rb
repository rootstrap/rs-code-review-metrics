module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class PullRequestSize
        def retrieve_records(entity_id:, time_range:)
          ::PullRequestSize
            .joins(pull_request: { project: { language: :department } })
            .where(departments: { id: entity_id })
            .where(pull_requests: { opened_at: time_range })
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PrSize.call(entity.value)
        end
      end
    end
  end
end
