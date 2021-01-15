module Builders
  module Chartkick
    module DepartmentDistributionDataMetrics
      class PullRequestSize
        def retrieve_records(entity_id:, time_range:)
          ::Events::PullRequest
            .joins(project: { language: :department })
            .where(departments: { id: entity_id })
            .where(opened_at: time_range)
            .where.not(size: nil)
        end

        def resolve_interval(entity)
          Metrics::IntervalResolver::PrSize.call(entity.size)
        end
      end
    end
  end
end
